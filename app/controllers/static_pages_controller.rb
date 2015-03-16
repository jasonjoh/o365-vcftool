require 'ruby_outlook'
include ApplicationHelper
class StaticPagesController < ApplicationController
  def home
    if logged_in?
      user = current_user
      outlook_client = RubyOutlook::Client.new
      outlook_client.enable_fiddler = true
      
      view_size = 30
      page = 1
      fields = [
        "DisplayName"
      ]
      sort = { :sort_field => 'DisplayName', :sort_order => 'ASC' }
      
      wrapped_contacts = outlook_client.get_contacts user.access_token,
        view_size, page, fields, sort
        
      @contacts = wrapped_contacts['value']
    end
  end
end
