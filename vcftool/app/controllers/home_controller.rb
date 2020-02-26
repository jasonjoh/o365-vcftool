# frozen_string_literal: true

# HomeController
class HomeController < ApplicationController
  def index
    return if access_token.nil?

    redirect_to contacts_path
  end
end
