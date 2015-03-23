# Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See full license at the bottom of this file.
require 'ruby_outlook'
include Vcard2o365Helper

class VCardImportController < ApplicationController
  def import
    # Get the file path from the session
    file = session[:current_upload]
    if not file.nil?
      # Open the file and read it's data
      @vcard = File.open(file).read
      # Delete the file path from the session
      session.delete(:current_upload)
    end
  end
  
  def upload
    # Upload the selected file to the server
    vcf_file = params[:vcard_file]
    uploader = VCardFileUploader.new
    uploader.store!(vcf_file)
    # Save the file path to the session
    session[:current_upload] = uploader.file.file
    redirect_to import_url
  end
  
  def create_contacts
    vcard = params[:vcard]
    if not vcard.nil?
      # Convert the vCard data to an array of JSON contact entities
      o365_contacts = vcard_file_to_o365_contact_array(vcard)
      
      # Since there may be more than one card in the file,
      # And the Contacts API doesn't support batch upload yet,
      # Create each one individually.
      if o365_contacts.any?
        outlook_client = RubyOutlook::Client.new
        outlook_client.enable_fiddler = true
        
        success = Array.new
        error = Array.new
      
        o365_contacts.each do |contact|
          # Call the ruby_outlook gem to create the contact
          response = outlook_client.create_contact current_user.access_token, contact
          
          # Refresh token and retry on 401 error
          if not response['ruby_outlook_error'].nil? and response['ruby_outlook_error'] = 401
            get_token_from_refresh_token(current_user)
            response = outlook_client.create_contact current_user.access_token, contact
          end
          
          if response['ruby_outlook_error'].nil?
            success << "Successfully imported #{response['DisplayName']}."
          else
            error << "Error importing #{contact['DisplayName']}: #{response['ruby_outlook_error']}."
          end
        end
        
        flash[:success] = success if success.any?
        flash[:danger] = error if error.any?
      end
      
      redirect_to root_url
    end
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