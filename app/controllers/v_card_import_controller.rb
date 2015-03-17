require 'ruby_outlook'
include Vcard2o365Helper

class VCardImportController < ApplicationController
  def import
    file = session[:current_upload]
    if not file.nil?
      @vcard = File.open(file).read
      session.delete(:current_upload)
    end
  end
  
  def upload
    vcf_file = params[:vcard_file]
    uploader = VCardFileUploader.new
    uploader.store!(vcf_file)
    session[:current_upload] = uploader.file.file
    redirect_to import_url
  end
  
  def create_contacts
    vcard = params[:vcard]
    if not vcard.nil?
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
