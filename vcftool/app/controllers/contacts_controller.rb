# frozen_string_literal: true

# ContactsController
class ContactsController < ApplicationController
  include GraphHelper
  def index
    redirect_to root_path if access_token.nil?

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
