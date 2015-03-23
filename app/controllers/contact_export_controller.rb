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
    
    contact = outlook_client.get_contact_by_id current_user.access_token, contact_id
    if contact.nil? or not contact['ruby_outlook_error'].nil?
      flash[:danger] = contact.nil? ? "Couldn't access contact." : contact['ruby_outlook_error']
    end
    
    @vcard = o365_contact_to_vcard(contact)
    @contact_name = contact['DisplayName']
  end
  
  def download
    vcard = params[:vcard]
    
    if vcard.nil?
      flash[:danger] = "No vcard data to download."
      redirect_to root_url
    end
    
    file_name = params[:contact_name] + '.vcf'
    
    send_data vcard, :filename => file_name
  end
end
