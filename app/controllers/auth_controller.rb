class AuthController < ApplicationController
  include AuthHelper
  
  def gettoken
    token = get_token_from_code params[:code]
    session[:o365_access_token] = token.token
    session[:o365_refresh_token] = token.refresh_token
    session[:o365_token_expires] = token.expires_at
    
    user_info = get_user_from_id_token(token.params['id_token'])
    session[:o365_user_name] = user_info['name']
    session[:o365_email] = user_info['upn']
    redirect_to root_url
  end
  
  def logout
    # Clear session variables
    session.delete(:o365_access_token)
    session.delete(:o365_refresh_token)
    session.delete(:o365_token_expires)
    session.delete(:o365_user_name)
    session.delete(:o365_email)
    
    redirect_to get_logout_url(root_url)
  end
end
