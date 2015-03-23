# Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See full license at the bottom of this file.
require 'ruby_outlook'
include Vcard2o365Helper

class ContactExportController < ApplicationController
  def export
    contact_id = params[:contact_id]
    
    if contact_id.nil?
      flash[:danger] = "No contact selected!"
      redirect_to root_url
    end
    
    outlook_client = RubyOutlook::Client.new
    outlook_client.enable_fiddler = true
    
    # Call the ruby_outlook gem to get the contact from its ID
    contact = outlook_client.get_contact_by_id current_user.access_token, contact_id
    if contact.nil? or not contact['ruby_outlook_error'].nil?
      flash[:danger] = contact.nil? ? "Couldn't access contact." : contact['ruby_outlook_error']
    end
    
    # Convert the contact to vCard
    @vcard = o365_contact_to_vcard(contact)
    @contact_name = contact['DisplayName']
  end
  
  def download
    vcard = params[:vcard]
    
    if vcard.nil?
      flash[:danger] = "No vcard data to download."
      redirect_to root_url
    end
    
    # Build a file name based on the contact's display name
    file_name = params[:contact_name] + '.vcf'
    
    # Send the data to the client
    send_data vcard, :type => 'text/vcard', :filename => file_name
  end
end

# MIT License: 
 
# Permission is hereby granted, free of charge, to any person obtaining 
# a copy of this software and associated documentation files (the 
# ""Software""), to deal in the Software without restriction, including 
# without limitation the rights to use, copy, modify, merge, publish, 
# distribute, sublicense, and/or sell copies of the Software, and to 
# permit persons to whom the Software is furnished to do so, subject to 
# the following conditions: 
 
# The above copyright notice and this permission notice shall be 
# included in all copies or substantial portions of the Software. 
 
# THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.