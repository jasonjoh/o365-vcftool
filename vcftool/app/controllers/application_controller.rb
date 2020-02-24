# frozen_string_literal: true

require 'microsoft_graph_auth'
require 'oauth2'

# ApplicationController
class ApplicationController < ActionController::Base
  before_action :set_user

  def set_user
    @user_name = user_name
    @user_email = user_email
    @user_avatar = user_avatar
    @user_initials = user_initials
  end

  def save_in_session(auth_hash)
    # Save the token info
    session[:graph_token_hash] = auth_hash.dig(:credentials)
    # Save the user's display name
    session[:user_name] = auth_hash.dig(:extra, :raw_info, :displayName)
    # Save the user's email address
    # Use the mail field first. If that's empty, fall back on
    # userPrincipalName
    session[:user_email] = auth_hash.dig(:extra, :raw_info, :mail) ||
                           auth_hash.dig(:extra, :raw_info, :userPrincipalName)
    session[:user_avatar] = auth_hash.dig(:extra, :raw_info, :photo)
    generate_initials auth_hash if session[:user_avatar].nil?
  end

  def generate_initials(auth_hash)
    logger.debug 'generate_initials called'
    # If no avatar, get user's initials
    given_name = auth_hash.dig(:extra, :raw_info, :givenName)
    surname = auth_hash.dig(:extra, :raw_info, :surname)
    session[:user_initials] = given_name.first + surname.first
  end

  def user_name
    session[:user_name]
  end

  def user_email
    session[:user_email]
  end

  def user_avatar
    session[:user_avatar]
  end

  def user_initials
    session[:user_initials]
  end

  def access_token
    token_hash = session[:graph_token_hash]

    # Get the expiry time - 5 minutes
    expiry = Time.at(token_hash[:expires_at] - 300)

    if Time.now > expiry
      # Token expired, refresh
      new_hash = refresh_tokens token_hash
      new_hash[:token]
    else
      token_hash[:token]
    end
  end

  def app_id
    Rails.application.credentials.azure[:app_id]
  end

  def app_secret
    Rails.application.credentials.azure[:app_secret]
  end

  def refresh_tokens(token_hash)
    oauth_strategy = OmniAuth::Strategies::MicrosoftGraphAuth.new(
      nil, app_id, app_secret
    )

    token = OAuth2::AccessToken.new(oauth_strategy.client,
                                    token_hash[:token],
                                    refresh_token: token_hash[:refresh_token])

    # Refresh the tokens
    new_tokens = token.refresh!.to_hash.slice(:access_token, :refresh_token,
                                              :expires_at)
    # Rename token key
    new_tokens[:token] = new_tokens.delete :access_token
    # Store the new hash
    session[:graph_token_hash] = new_tokens
  end
end
