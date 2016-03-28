# Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See full license at the bottom of this file.
class AuthController < ApplicationController
  include AuthHelper
  
  def gettoken
    # Exchange the auth code for an access token
    token = get_token_from_code params[:code]
    
    # Parse the id token to get the user's information (name, email)
    user_info = get_user_from_id_token(token.token)
    
    # Find the user by email address in the database
    user = User.find_by(email: user_info['unique_name'])
    if user.nil?
      # If the user doesn't exist, create a new record
      user = User.create(name: user_info['name'],
                         email: user_info['unique_name'],
                         access_token: token.token,
                         refresh_token: token.refresh_token,
                         token_expires: token.expires_at)
    else
      # Update existing user with new tokens
      user.access_token = token.token
      user.refresh_token = token.refresh_token
      user.token_expires = token.expires_at
      user.save
    end
    
    # Save the user ID in the session
    session[:user_id] = user.id
    
    redirect_to root_url
  end
  
  def logout
    # Delete user from database
    user = User.find_by(id: session[:user_id])
		if !user.nil?
    	user.destroy
		end
    
    # Clear session variables
    session.delete(:user_id)
    
    redirect_to root_url
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