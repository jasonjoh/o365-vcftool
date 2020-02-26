# frozen_string_literal: true

require 'microsoft_graph_auth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :microsoft_graph_auth,
           Rails.application.credentials.azure[:app_id],
           Rails.application.credentials.azure[:app_secret],
           scope: 'https://graph.microsoft.com/.default offline_access'
end
