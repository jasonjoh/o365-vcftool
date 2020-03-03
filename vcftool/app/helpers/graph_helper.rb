# frozen_string_literal: true

require 'httparty'

# Graph API helper methods
module GraphHelper
  GRAPH_HOST = 'https://graph.microsoft.com'

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

  def get_contact(token, contact_id)
    headers = { Authorization: "Bearer #{token}" }

    request = "#{GRAPH_HOST}/v1.0/me/contacts/#{contact_id}"

    response = HTTParty.get request, headers: headers
    response.parsed_response
  end

  def update_contact(token, contact_id, contact)
    headers = {
      Authorization: "Bearer #{token}",
      'Content-Type': 'application/json'
    }

    request = "#{GRAPH_HOST}/v1.0/me/contacts/#{contact_id}"

    response = HTTParty.patch request, headers: headers, body: contact.to_json
    response.parsed_response
  end
end
