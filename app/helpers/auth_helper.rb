require 'base64'

module AuthHelper

  # App's client ID. Register the app in Azure AD to get this value.
  CLIENT_ID = 'YOUR CLIENT ID HERE'
  # App's client secret. Register the app in Azure AD to get this value.
  CLIENT_SECRET = 'YORU CLIENT SECRET HERE'

  # Generates the login URL for the app.
  def get_login_url
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                :site => "https://login.windows.net",
                                :authorize_url => "/common/oauth2/authorize",
                                :token_url => "/common/oauth2/token")

    login_url = client.auth_code.authorize_url(:redirect_uri => authorize_url)
  end
  
  def get_logout_url(redirect_url)
    logout_url = "https://login.windows.net/common/oauth2/logout?"
    logout_url << { post_logout_redirect_uri: redirect_url }.to_param
  end
  
  # Exchanges an authorization code for a token
  def get_token_from_code(auth_code)
    client = OAuth2::Client.new(CLIENT_ID,
                                CLIENT_SECRET,
                                :site => "https://login.windows.net",
                                :authorize_url => "/common/oauth2/authorize",
                                :token_url => "/common/oauth2/token")

    token = client.auth_code.get_token(auth_code,
                                       :redirect_uri => authorize_url,
                                       :resource => 'https://outlook.office365.com')

    access_token = token
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
