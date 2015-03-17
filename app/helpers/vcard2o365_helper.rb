require 'vcard'
require 'JSON'

module Vcard2o365Helper
  # Build a string value for the ORG field in vCard.
  # The format is "Company Name";"Department"
  def make_org_string(company_name, department)
    if company_name.nil? && department.nil?
      return nil
    else
      org_string = (company_name.nil? ? '' : company_name) +
        (department.nil? ? '' : ';' + department)
    end
  end

  # Because blank address fields in the REST API come back as non-empty
  # but with a value of 'nil' for all of the fields, check for any
  # non-nil field.
  def is_json_empty(json)
    puts "Checking if empty: " + json.inspect
    json.each_value do |field|
      if not field.nil?
        return false
      end
    end
    
    return true
  end

  # Creates a vCard from a single Office 365 Contact entity
  # The 'o365_contact' parameter is a JSON hash returned from JSON.parse
  # Return value is a Vcard object
  def o365_contact_to_vcard(o365_contact)
    card = Vcard::Vcard::Maker.make2 do |maker|
      # Name
      display_name =  o365_contact['DisplayName']
      given_name =    o365_contact['GivenName']
      middle_name =   o365_contact['MiddleName']
      surname =       o365_contact['Surname']
      title =         o365_contact['Title']
      suffix =        o365_contact['Generation']
      
      maker.add_name do |name|
        name.fullname = display_name if not display_name.nil?
        name.given = given_name if not given_name.nil?
        name.additional = middle_name if not middle_name.nil?
        name.family = surname if not surname.nil?
        name.prefix = title if not title.nil?
        name.suffix = suffix if not suffix.nil?
      end
      
      # Other identification information
      nickname = o365_contact['NickName']
      maker.nickname = nickname if not nickname.nil?
      
      profession = o365_contact['Profession']
      maker.add_role profession if not profession.nil?
      
      birthday = o365_contact['Birthday']
      maker.birthday = Date.parse(birthday) if not birthday.nil?
      
      # Work stuff
      company_name = o365_contact['CompanyName']
      department = o365_contact['Department']
      org_string = make_org_string(company_name, department)
      maker.org = org_string if not org_string.nil?
      
      jobtitle = o365_contact['JobTitle']
      maker.title = jobtitle if not jobtitle.nil?
      
      # Note: Outlook exports this as URL;WORK:<value>
      # However there seems to be no obvious way to apply this to URL via
      # the vCard library.
      biz_home_page = o365_contact['BusinessHomePage']
      maker.add_url(biz_home_page) if not biz_home_page.nil?
      
      assistant = o365_contact['AssistantName']
      maker.add_assistant assistant if not assistant.nil?
      
      manager = o365_contact['Manager']
      maker.add_manager manager if not manager.nil?
      
      # Email addresses
      need_preferred = true
      o365_contact['EmailAddresses'].each do |email|
        if not email.nil?
          maker.add_email(email['Address']) { |e| e.preferred = need_preferred }
          need_preferred = false
        end
      end
      
      # Phone numbers
      o365_contact['BusinessPhones'].each do |biz_phone|
        if not biz_phone.nil?
          maker.add_tel(biz_phone) { |t| t.location = 'WORK' }
        end
      end
      
      o365_contact['HomePhones'].each do |home_phone|
        if not home_phone.nil?
          maker.add_tel(home_phone) { |t| t.location = 'HOME' }
        end
      end
      
      mobile_phone = o365_contact['MobilePhone1']
      if not mobile_phone.nil?
        maker.add_tel(mobile_phone) { |t| t.location = 'CELL' }
      end
      
      # Addresses
      business_addr = o365_contact['BusinessAddress']
      office_location = o365_contact['OfficeLocation']
      
      if (not business_addr.nil? and not is_json_empty(business_addr)) or not office_location.nil?
        maker.add_addr do |addr|
          addr.location = 'WORK'
          if not business_addr.nil?
            addr.street = business_addr['Street'] if not business_addr['Street'].nil?
            addr.locality = business_addr['City'] if not business_addr['City'].nil?
            addr.country = business_addr['CountryOrRegion'] if not business_addr['CountryOrRegion'].nil?
            addr.postalcode= business_addr['PostalCode'] if not business_addr['PostalCode'].nil?
            addr.region = business_addr['State'] if not business_addr['State'].nil?
          end
          if not office_location.nil?
            addr.extended = office_location if not office_location.nil?
          end
        end
      end
      
      home_addr = o365_contact['HomeAddress']
      if not home_addr.nil? and not is_json_empty(home_addr)
        maker.add_addr do |addr|
          addr.location = 'HOME'
          addr.street = home_addr['Street'] if not home_addr['Street'].nil?
          addr.locality = home_addr['City'] if not home_addr['City'].nil?
          addr.country = home_addr['CountryOrRegion'] if not home_addr['CountryOrRegion'].nil?
          addr.postalcode= home_addr['PostalCode'] if not home_addr['PostalCode'].nil?
          addr.region = home_addr['State'] if not home_addr['State'].nil?
        end
      end
      
      other_addr = o365_contact['OtherAddress']
      if not other_addr.nil? and not is_json_empty(other_addr)
        maker.add_addr do |addr|
          addr.location = 'POSTAL'
          addr.street = other_addr['Street'] if not other_addr['Street'].nil?
          addr.locality = other_addr['City'] if not other_addr['City'].nil?
          addr.country = other_addr['CountryOrRegion'] if not other_addr['CountryOrRegion'].nil?
          addr.postalcode= other_addr['PostalCode'] if not other_addr['PostalCode'].nil?
          addr.region = other_addr['State'] if not other_addr['State'].nil?
        end
      end
      
      # IM Address
      o365_contact['ImAddresses'].each do |im_address|
        if not im_address.nil?
          maker.add_im_address im_address
        end
      end
      
      # Categories
      categories = o365_contact['Categories']
      if not categories.nil?
        maker.add_categories categories
      end
    end
  end

  # Takes an array of one or more Office 365 contacts
  # and converts them into a vCard file.
  # The 'o365_contacts' parameter should be an array of 
  # JSON hashes returned from JSON.parse
  # The return value is an Array of Vcard objects
  def o365_contact_array_to_vcard_file(o365_contacts)
    cards = Array.new
    o365_contacts.each do |contact|
      vcard = o365_contact_to_vcard(contact)
      cards.push(vcard)
    end
    
    return cards
  end

  # Converts a single vCard entry into an
  # Office 365 JSON contact. 
  # The 'vcard' parameter is a Vcard object
  # The return value is a JSON hash
  def vcard_to_o365_contact(vcard)
    contact = Hash.new
    # Name
    contact['DisplayName'] = vcard.name.fullname if not vcard.name.fullname.nil?
    contact['GivenName'] = vcard.name.given if not vcard.name.given.nil?
    contact['MiddleName'] = vcard.name.additional if not vcard.name.additional.nil?
    contact['Surname'] = vcard.name.family if not vcard.name.family.nil?
    contact['Title'] = vcard.name.prefix if not vcard.name.prefix.nil?
    contact['Generation'] = vcard.name.suffix if not vcard.name.suffix.nil?
    
    # Other identification information
    contact['NickName'] = vcard.nickname if not vcard.nickname.nil?
    
    contact['Profession'] = vcard.role if not vcard.role.nil?
    
    # TODO: Timezone consideration here.
    contact['Birthday'] = vcard.birthday.strftime('%Y-%m-%dT00:00:00Z') if not vcard.birthday.nil?
    
    # Work stuff
    if not vcard.org.nil?
      contact['CompanyName'] = vcard.org[0] if not vcard.org[0].nil?
      contact['Department'] = vcard.org[1] if not vcard.org[1].nil?
    end
    
    contact['JobTitle'] = vcard.title if not vcard.title.nil?
    contact['BusinessHomePage'] = vcard.url.uri if not vcard.url.nil?
    contact['AssistantName'] = vcard['X-MS-ASSISTANT'] if not vcard['X-MS-ASSISTANT'].nil?
    contact['Manager'] = vcard['X-MS-MANAGER'] if not vcard['X-MS-MANAGER'].nil?
    
    # Email addresses
    # In the O365 format, a contact is limited to 3 email addresses.
    # The first entry in the JSON object is the preferred address.
    if not vcard.emails.nil?
      emails = Array.new
      vcard.emails.each do |email|
        if email.preferred
          # Add to the beginning of the array
          emails.unshift( { 'Address' => email.to_str } )
        else
          # Add to the end of the array
          emails.push( { 'Address' => email.to_str } )
        end
      end
      
    contact['EmailAddresses'] = emails.take(3)
    end
    
    # Phone numbers
    # O365 format allows:
    #  - 2 Business phones
    #  - 2 Home phones
    #  - 1 Mobile phone
    if not vcard.telephones.nil?
      biz_phones = Array.new
      home_phones = Array.new
      mobile_phones = Array.new
      vcard.telephones.each do |phone|
        if phone.location.include?('work')
          biz_phones.push(phone.to_str)
        elsif phone.location.include?('home')
          home_phones.push(phone.to_str)
        elsif phone.location.include?('cell')
          mobile_phones.push(phone.to_str)
        end
      end
      
      contact['BusinessPhones'] = biz_phones.take(2) if not biz_phones.empty?
      contact['HomePhones'] = home_phones.take(2) if not biz_phones.empty?
      contact['MobilePhone1'] = mobile_phones.first if not mobile_phones.empty?
    end
    
    # Addresses
    if not vcard.addresses.nil?
      work_addr = home_addr = other_addr = nil
      vcard.addresses.each do |addr|
        if addr.location.include?('work')
          if work_addr.nil? or addr.preferred
            work_addr = addr
          end
        elsif addr.location.include?('home')
          if home_addr.nil? or addr.preferred
            home_addr = addr
          end
        else
          if other_addr.nil? or addr.preferred
            other_addr = addr
          end
        end
      end
      
      if not work_addr.nil?
        o365_work_addr = {
          'Street' => work_addr.street,
          'City' => work_addr.locality,
          'CountryOrRegion' => work_addr.country,
          'PostalCode' => work_addr.postalcode,
          'State' => work_addr.region
        }
        
        contact['BusinessAddress'] = o365_work_addr
      end
      
      if not home_addr.nil?
        o365_home_addr = {
          'Street' => home_addr.street,
          'City' => home_addr.locality,
          'CountryOrRegion' => home_addr.country,
          'PostalCode' => home_addr.postalcode,
          'State' => home_addr.region
        }
        
        contact['HomeAddress'] = o365_home_addr
      end
      
      if not other_addr.nil?
        o365_other_addr = {
          'Street' => other_addr.street,
          'City' => other_addr.locality,
          'CountryOrRegion' => other_addr.country,
          'PostalCode' => other_addr.postalcode,
          'State' => other_addr.region
        }
        
        contact['OtherAddress'] = o365_other_addr
      end
    end
    
    # IM Address
    contact['ImAddresses'] = [ vcard['X-MS-IMADDRESS'] ] if not vcard['X-MS-IMADDRESS'].nil?
    
    # Categories
    contact['Categories'] = vcard.categories if not vcard.categories.nil?
    
    return contact
  end
end

# Converts a vCard stream with one or more vCard entries
# into an array of Office 365 JSON contacts.
# The 'vcard_file' parameter is the contents of a vCard file
# The return value is an array of JSON hashes.
def vcard_file_to_o365_contact_array(vcard_file)
  contacts = Array.new
  # A vCard file can have multiple cards within it, so
  # this returns an array.
  cards = Vcard::Vcard.decode(vcard_file)
  cards.each do |card|
    contact = vcard_to_o365_contact(card)
    
    contacts.push(contact)
  end
  
  return contacts
end

# Extensions to the Vcard::Maker class to add new
# fields.
module Vcard
  class Vcard
    class Maker
      def add_assistant(assistant)
        # Custom field Outlook uses to store assistant name
        @card << ::Vcard::DirectoryInfo::Field.create( 'X-MS-ASSISTANT', assistant.to_str );
      end
      
      def add_manager(manager)
        # Custom field Outlook uses to store manager name
        @card << ::Vcard::DirectoryInfo::Field.create( 'X-MS-MANAGER', manager.to_str );
      end
      
      def add_im_address(im_address)
        # Custom field Outlook uses to store IM address
        @card << ::Vcard::DirectoryInfo::Field.create( 'X-MS-IMADDRESS', im_address.to_str );
      end
      
      def add_categories(categories)
        category_string = categories.join(',')
        # Defined in http://www.ietf.org/rfc/rfc2426.txt
        @card << ::Vcard::DirectoryInfo::Field.create( 'CATEGORIES', category_string );
      end
    end
  end
end