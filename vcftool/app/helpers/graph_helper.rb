# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# frozen_string_literal: true

require 'httparty'

# Graph API helper methods
module GraphHelper
  GRAPH_HOST = 'https://graph.microsoft.com'

  # Get a list of contacts
  def get_contacts(token, request_url)
    headers = { Authorization: "Bearer #{token}" }

    # Method takes a request URL parameter
    # this is to allow for pagination. Per the docs,
    # you should do a GET on the @odata.nextLink URL, not
    # build the request yourself
    if request_url.nil?
      params = {
        '$select': 'displayName,id', '$orderby': 'displayName',
        '$top': 12 # default to 12 contacts per page
      }
    end

    request = request_url || "#{GRAPH_HOST}/v1.0/me/contacts"

    response = HTTParty.get request, headers: headers, query: params
    response.parsed_response
  end

  # Get contact by ID
  def get_contact(token, contact_id)
    headers = { Authorization: "Bearer #{token}" }

    request = "#{GRAPH_HOST}/v1.0/me/contacts/#{contact_id}"

    response = HTTParty.get request, headers: headers
    response.parsed_response
  end

  # Update a contact
  def update_contact(token, contact_id, contact)
    headers = {
      Authorization: "Bearer #{token}",
      'Content-Type': 'application/json'
    }

    request = "#{GRAPH_HOST}/v1.0/me/contacts/#{contact_id}"

    response = HTTParty.patch request, headers: headers, body: contact.to_json
    response.parsed_response
  end

  # Create new contact
  def create_contact(token, contact)
    headers = {
      Authorization: "Bearer #{token}",
      'Content-Type': 'application/json'
    }

    request = "#{GRAPH_HOST}/v1.0/me/contacts"

    response = HTTParty.post request, headers: headers, body: contact.to_json
    response.parsed_response
  end
end
