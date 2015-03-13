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
    return not(session[:o365_access_token].nil?)
  end
  
  # Returns the current user's name.
  def current_user
    return session[:o365_user_name]
  end
  
  # Extracts the session values used by the app.
  def get_session_vals
    if logged_in?
      session_values = {
        'o365_user_name' => session[:o365_user_name],
        'o365_email' => session[:o365_email],
        'o365_access_token' => session[:o365_access_token],
        'o365_refresh_token' => session[:o365_refresh_token],
        'o365_token_expires' => session[:o365_token_expires]
      }
    end
  end
end
