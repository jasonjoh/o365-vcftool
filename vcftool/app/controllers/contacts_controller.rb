# frozen_string_literal: true

# ContactsController
class ContactsController < ApplicationController
  include GraphHelper
  include VcardHelper

  before_action :require_token

  def require_token
    redirect_to root_path if access_token.nil?
  end

  def index
    @back_disabled = session[:current_page].nil?

    @contacts = get_contacts access_token, session[:current_page]

    session[:next_page] = @contacts['@odata.nextLink']
  end

  def next
    push_prev_page session[:current_page]
    logger.debug "Prev pages: #{session[:prev_pages]}"
    session[:current_page] = session[:next_page]
    redirect_to contacts_path
  end

  def prev
    prev_page = pop_prev_page
    prev_page = nil if prev_page&.empty?
    session[:current_page] = prev_page
    redirect_to contacts_path
  end

  def reset
    session.delete :prev_pages
    session.delete :current_page
    session.delete :next_page
    redirect_to contacts_path
  end

  def edit
    @contact = get_contact access_token, params[:id]
    @vcard = graph_to_vcard @contact
  end

  def download
    contact = get_contact access_token, params[:id]
    vcard = graph_to_vcard contact

    send_data vcard, filename: "#{contact['displayName'] || 'contact'}.vcf"
  end

  def update
    error = update_from_vcard params[:vcard], params[:id]

    unless error.nil?
      redirect_to contacts_edit_path(params[:id]), alert: error
      return
    end

    redirect_to contacts_path, notice: 'Contact updated'
  end

  def update_from_vcard(card, id)
    contact = vcard_to_graph(card, logger)
    error = check_result contact
    return error unless error.nil?

    apiresponse = update_contact access_token, id, contact
    check_api_response apiresponse
  end

  def check_api_response(response)
    return if response.nil?

    return unless response.key? 'error'

    {
      message: response['error']['message'],
      debug: resonse.to_json
    }
  end

  def check_result(contact)
    'The vCard text could not be parsed.' if contact.nil?

    'The vCard text must contain only one contact.' if contact.is_a?(Array)
  end

  def push_prev_page(prev_page)
    prev_pages = session[:prev_pages]
    prev_pages = [] if prev_pages.nil?
    prev_pages.push prev_page || ''
    session[:prev_pages] = prev_pages
  end

  def pop_prev_page
    prev_pages = session[:prev_pages]
    prev_pages&.pop
  end
end
