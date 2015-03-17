class AuthController < ApplicationController
  include AuthHelper
  
  def gettoken
    token = get_token_from_code params[:code]
    
    user_info = get_user_from_id_token(token.params['id_token'])
    
    user = User.find_by(email: user_info['upn'])
    if user.nil?
      user = User.create(name: user_info['name'],
                         email: user_info['upn'],
                         access_token: token.token,
                         refresh_token: token.refresh_token,
                         token_expires: token.expires_at)
    else
      user.access_token = token.token
      user.refresh_token = token.refresh_token
      user.token_expires = token.expires_at
      user.save
    end
    
    session[:user_id] = user.id
    
    redirect_to root_url
  end
  
  def logout
    # Delete user from database
    user = User.find_by(id: session[:user_id])
    user.destroy
    
    # Clear session variables
    session.delete(:user_id)
    
    redirect_to get_logout_url(root_url)
  end
end
