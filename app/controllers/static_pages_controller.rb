require 'ruby_outlook'
include ApplicationHelper
include AuthHelper
class StaticPagesController < ApplicationController
  def home
    if logged_in?
      user = current_user
      outlook_client = RubyOutlook::Client.new
      outlook_client.enable_fiddler = true
      
      view_size = 30
      page = params[:page].nil? ? 1 : params[:page].to_i
      fields = [
        "DisplayName"
      ]
      sort = { :sort_field => 'DisplayName', :sort_order => 'ASC' }
      
      logger.debug "Calling get_contacts (first time)"
      wrapped_contacts = outlook_client.get_contacts user.access_token,
        view_size, page, fields, sort
        
      # Refresh token and retry on 401 error
      if not wrapped_contacts['ruby_outlook_error'].nil? and wrapped_contacts['ruby_outlook_error'] = 401
        get_token_from_refresh_token(user)
        # Reload user from db to get new access token value
        user = current_user
        wrapped_contacts = outlook_client.get_contacts user.access_token,
          view_size, page, fields, sort
      end
        
      if (wrapped_contacts['ruby_outlook_error'].nil?)
        @contacts = wrapped_contacts
      else
        flash.now[:danger] = "Error retrieving contacts: #{wrapped_contacts['ruby_outlook_error']}"
      end
    end
  end
end
