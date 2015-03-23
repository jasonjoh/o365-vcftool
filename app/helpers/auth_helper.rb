# Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See full license at the bottom of this file.
require 'base64'

module AuthHelper

  # App's client ID. Register the app in Azure AD to get this value.
  CLIENT_ID = 'YOUR CLIENT ID HERE'
  # App's client secret. Register the app in Azure AD to get this value.
  CLIENT_SECRET = 'YOUR CLIENT SECRET HERE'

  # Generates the login URL for the app.
  def get_login_url
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                :site => "https://login.microsoftonline.com",
                                :authorize_url => "/common/oauth2/authorize",
                                :token_url => "/common/oauth2/token")

    login_url = client.auth_code.authorize_url(:redirect_uri => authorize_url)
  end
  
  # Generates the logout URL for the app.
  def get_logout_url(redirect_url)
    logout_url = "https://login.microsoftonline.com/common/oauth2/logout?"
    logout_url << { post_logout_redirect_uri: redirect_url }.to_param
  end
  
  # Exchanges an authorization code for a token
  def get_token_from_code(auth_code)
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                :site => "https://login.microsoftonline.com",
                                :authorize_url => "/common/oauth2/authorize",
                                :token_url => "/common/oauth2/token")

    token = client.auth_code.get_token(auth_code,
                                       :redirect_uri => authorize_url,
                                       :resource => 'https://outlook.office365.com')

    access_token = token
  end
  
  # Refreshes an access token from a refresh token
  def get_token_from_refresh_token(user)
    logger.debug "BEGIN get_token_from_refresh_token"
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                :site => "https://login.microsoftonline.com",
                                :authorize_url => "/common/oauth2/authorize",
                                :token_url => "/common/oauth2/token")
                                
    current_token = OAuth2::AccessToken.from_hash(client,
      { :refresh_token => user.refresh_token })
    
    logger.debug "Current token: #{current_token.inspect}"
    
    new_token = current_token.refresh!
    logger.debug "New token: #{new_token.inspect}"
    
    user.access_token = new_token.token
    user.refresh_token = new_token.refresh_token
    user.save
  end
  
  # Parses an id token to get user information
  def get_user_from_id_token(id_token)
    # Split the string on '.'
    token_parts = id_token.split('.')
    
    # token_parts[0] is header
    # token_parts[1] is JWT
    encoded_token = token_parts[1]
    
    # Check padding and add if needed
    case encoded_token.length % 4
      when 2
        # Add 2 pad chars
        encoded_token << '=='
      when 3
        # Add 1 pad char
        encoded_token << '='
    end
    
    decoded_token = JSON.parse(Base64.urlsafe_decode64(encoded_token))
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