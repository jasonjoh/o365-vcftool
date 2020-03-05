# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# frozen_string_literal: true

# ContactsHelper
module ContactsHelper
  def check_api_response(response)
    return if response.nil?

    return unless response.key? 'error'

    {
      message: response['error']['message'],
      debug: response.to_json
    }
  end

  def check_result(contacts)
    'The vCard text could not be parsed.' if contacts.nil?

    'The vCard text must contain only one contact.' if contacts.length > 1
  end

  def alert_from_errors(errors)
    return unless errors.any?

    debugitems = []
    errors.each do |error|
      debugitems.push error unless error.nil?
    end

    {
      message: "#{debugitems.length} errors encountered when creating contacts",
      debug: debugitems.to_json
    }
  end
end
