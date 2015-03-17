module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Office 365 Contact Import/Export Tool"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  # Returns true if there is a logged on Office 365 user.
  def logged_in?
    return not(session[:user_id].nil?)
  end
  
  # Returns the current user's name.
  def current_user
    user = User.find_by(id: session[:user_id])
    return user.nil? ? nil : user
  end
  
  # Extracts the session values used by the app.
  def get_session_vals
    if logged_in?
      user = User.find_by(id: session[:user_id])
      session_values = {
        'user_id' => session[:user_id],
        'User Name' => user.name,
        'User Email' => user.email,
        'Access Token' => user.access_token,
        'Refresh Token' => user.refresh_token,
        'Token Expires' => user.token_expires,
        'Current Upload' => session[:current_upload]
      }
    end
  end
end
