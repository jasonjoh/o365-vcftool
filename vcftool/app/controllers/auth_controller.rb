# frozen_string_literal: true

# AuthController
class AuthController < ApplicationController
  def callback
    # Access the authentication hash for omniauth
    data = request.env['omniauth.auth']

    # Temporary for testing!
    render json: data.to_json
  end
end
