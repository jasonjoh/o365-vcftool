# Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See full license at the bottom of this file.
require 'ruby_outlook'
include ApplicationHelper
include AuthHelper

class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # If the user is logged in, get their contacts
      user = current_user
      outlook_client = RubyOutlook::Client.new
      outlook_client.enable_fiddler = true
      
      # Maximum 30 results per page.
      view_size = 30
      # Set the page from the query parameter.
      page = params[:page].nil? ? 1 : params[:page].to_i
      # Only retrieve display name.
      fields = [
        "DisplayName"
      ]
      # Sort by display name
      sort = { :sort_field => 'DisplayName', :sort_order => 'ASC' }
      
      # Call the ruby_outlook gem
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

# MIT License: 
 
# Permission is hereby granted, free of charge, to any person obtaining 
# a copy of this software and associated documentation files (the 
# ""Software""), to deal in the Software without restriction, including 
# without limitation the rights to use, copy, modify, merge, publish, 
# distribute, sublicense, and/or sell copies of the Software, and to 
# permit persons to whom the Software is furnished to do so, subject to 
# the following conditions: 
 
# The above copyright notice and this permission notice shall be 
# included in all copies or substantial portions of the Software. 
 
# THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.