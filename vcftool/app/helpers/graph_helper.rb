# frozen_string_literal: true

require 'httparty'

# Graph API helper methods
module GraphHelper
  GRAPH_HOST = 'https://graph.microsoft.com'

  def make_api_call(endpoint, token, params = nil)
    headers = {
      Authorization: "Bearer #{token}"
    }

    query = params || {}

    HTTParty.get "#{GRAPH_HOST}#{endpoint}",
                 headers: headers,
                 query: query
  end

  def get_contacts(token, request_url)
    headers = { Authorization: "Bearer #{token}" }

    if request_url.nil?
      params = {
        '$select': 'displayName,id', '$orderby': 'displayName',
        '$top': 12
      }
    end

    request = request_url || "#{GRAPH_HOST}/v1.0/me/contacts"

    response = HTTParty.get request, headers: headers, query: params
    response.parsed_response
  end
end
