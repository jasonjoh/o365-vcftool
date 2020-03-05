# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

require 'microsoft_graph_auth'

Rails.application.config.middleware.use OmniAuth::Builder do
  unless Rails.application.credentials.azure.nil?
    provider :microsoft_graph_auth,
             Rails.application.credentials.azure[:app_id],
             Rails.application.credentials.azure[:app_secret],
             scope: 'https://graph.microsoft.com/.default offline_access'
  end
end
