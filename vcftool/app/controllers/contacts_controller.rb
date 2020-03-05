# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# frozen_string_literal: true

# ContactsController
class ContactsController < ApplicationController
  include GraphHelper
  include VcardHelper
  include ContactsHelper

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

  def create
    if params[:vcard].nil?
      redirect_to contacts_new_path, alert: 'Could not parse vCard.'
      return
    end

    contacts = vcard_to_graph params[:vcard]

    create_contacts contacts
  end

  def create_contacts(contacts)
    errors = []
    contacts.each do |contact|
      response = create_contact access_token, contact
      errors.push check_api_response(response)
    end

    alert = alert_from_errors errors

    redirect_to contacts_path,
                alert: alert,
                notice: ("Created #{contacts.length} contacts" if alert.nil?)
  end

  def update_from_vcard(card, id)
    contacts = vcard_to_graph(card)
    error = check_result contacts
    return error unless error.nil?

    apiresponse = update_contact access_token, id, contacts.first
    check_api_response apiresponse
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
