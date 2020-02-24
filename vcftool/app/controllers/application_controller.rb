# frozen_string_literal: true

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
    session[:graph_token_hash][:token]
  end
end
