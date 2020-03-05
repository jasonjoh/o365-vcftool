# frozen_string_literal: true

require 'vcard'

# rubocop:disable Metrics/ModuleLength
# Vcard helper methods
module VcardHelper
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/BlockLength
  def graph_to_vcard(contact)
    Vcard::Vcard::Maker.make2 do |maker|
      # Name
      maker.add_name do |name|
        name.fullname = contact['displayName'] || ''
        name.given = contact['givenName'] || ''
        name.additional = contact['middleName'] || ''
        name.family = contact['surname'] || ''
        name.prefix = contact['title'] || ''
        name.suffix = contact['generation'] || ''
      end

      # Other personal information
      maker.nickname = contact['nickName'] unless contact['nickName'].nil?

      unless contact['birthday'].nil?
        maker.birthday = Date.parse(contact['birthday'])
      end

      maker.add_spouse contact['spouseName'] unless contact['spouseName'].nil?

      unless contact['personalNotes'].nil?
        maker.add_note contact['personalNotes']
      end

      # Work information
      unless contact['companyName'].nil? && contact['department'].nil?
        maker.org = make_org_string contact['companyName'],
                                    contact['department']
      end

      maker.title = contact['jobTitle'] unless contact['jobTitle'].nil?
      maker.add_role contact['profession'] unless contact['profession'].nil?

      unless contact['businessHomePage'].nil?
        maker.add_url contact['businessHomePage']
      end

      unless contact['assistantName'].nil?
        maker.add_assistant contact['assistantName']
      end

      maker.add_manager contact['manager'] unless contact['manager'].nil?

      # Email addresses
      preferred = true # First email address is preferred
      contact['emailAddresses'].each do |email|
        unless email.nil?
          maker.add_email(email['address']) { |e| e.preferred = preferred }
          preferred = false
        end
      end

      # Phone numbers
      add_phone_numbers maker, contact['businessPhones'], 'WORK'
      add_phone_numbers maker, contact['homePhones'], 'HOME'
      add_phone_number maker, contact['mobilePhone'], 'CELL'

      # Addresses
      add_address maker,
                  contact['businessAddress'],
                  'WORK',
                  contact['officeLocation']

      add_address maker, contact['homeAddress'], 'HOME', nil
      add_address maker, contact['otherAddress'], 'POSTAL', nil

      # Categories
      unless contact['categories'].empty?
        maker.add_categories contact['categories']
      end

      # IM Addresses
      contact['imAddresses'].each do |address|
        next if address.nil?

        maker.add_im_address address
      end

      # Rev time
      maker.add_rev Time.parse(contact['lastModifiedDateTime'])
    end
  end

  def add_address(maker, address, type, extra)
    return if address.nil?

    maker.add_addr do |addr|
      addr.location = type
      addr.street = address['street'] unless address['street'].nil?
      addr.locality = address['city'] unless address['city'].nil?
      addr.region = address['state'] unless address['state'].nil?
      unless address['countryOrRegion'].nil?
        addr.country = address['countryOrRegion']
      end
      addr.postalcode = address['postalCode'] unless address['postalCode'].nil?
      addr.extended = extra unless extra.nil?
    end
  end

  def contact_from_card(card)
    contact = {}

    # Name
    contact['displayName'] = card.name.fullname
    contact['givenName'] = card.name.given
    contact['middleName'] = card.name.additional
    contact['surname'] = card.name.family
    contact['title'] = card.name.prefix
    contact['generation'] = card.name.suffix

    # Other personal information
    contact['nickName'] = card.nickname
    contact['birthday'] = card.birthday
    contact['spouseName'] = card.value('X-MS-SPOUSE')
    contact['personalNotes'] = card.note

    # Work information
    contact['companyName'] = card.org&.fetch(0, nil)
    contact['department'] = card.org&.fetch(1, nil)
    contact['jobTitle'] = card.title
    contact['profession'] = card.role
    contact['businessHomePage'] = card.url&.uri
    contact['assistantName'] = card.value('X-MS-ASSISTANT')
    contact['manager'] = card.value('X-MS-MANAGER')

    # Email addresses
    emails = []
    card.emails.each do |email|
      address = { address: email.to_s }
      if email.preferred
        emails.unshift address
      else
        emails.push address
      end
    end
    contact['emailAddresses'] = emails

    # Phone numbers
    process_vcard_telephones card, contact

    # Addresses
    process_vcard_addresses card, contact

    # Categories
    contact['categories'] = card.categories || []

    # IM Addresses
    im_addresses = card.values('X-MS-IMADDRESS')
    contact['imAddresses'] = []
    im_addresses&.each do |address|
      contact['imAddresses'].push address
    end

    contact
  end

  def process_vcard_telephones(card, contact)
    return if card.telephones.nil?

    # vCard phone numbers are all in one collection,
    # regardless of type. Need to iterate over the
    # collection and pull out the ones that map to Graph

    # Create arrays for different types
    bizphones = []
    homephones = []
    mobilephones = []

    card.telephones.each do |phone|
      if phone.location.include?('work')
        if phone.preferred
          bizphones.unshift phone.to_str
        else
          bizphones.push phone.to_str
        end
      elsif phone.location.include?('home')
        if phone.preferred
          homephones.unshift phone.to_str
        else
          homephones.push phone.to_str
        end
      elsif phone.location.include?('cell')
        if phone.preferred
          mobilephones.unshift phone.to_str
        else
          mobilephones.push phone.to_str
        end
      end

      # Personal contacts are limited to:
      # - 2 business phones
      # - 2 home phones
      # - 1 mobile phone
      contact['businessPhones'] = bizphones.take(2) unless bizphones.empty?
      contact['homePhones'] = homephones.take(2) unless homephones.empty?
      contact['mobilePhone'] = mobilephones.first unless mobilephones.empty?
    end
  end

  def process_vcard_addresses(card, contact)
    return if card.addresses.nil?

    # vCard addresses are all in one collection,
    # regardless of type. Need to iterate over the
    # collection and pull out the ones that map to Graph
    work_addr = home_addr = other_addr = nil

    # In case of multiple addresses of the same type,
    # default to using the first one found, unless one is
    # marked as the preferred address
    card.addresses.each do |address|
      if address.location.include?('work')
        work_addr = address if work_addr.nil? || address.preferred
      elsif address.location.include?('home')
        home_addr = address if home_addr.nil? || address.preferred
      elsif other_addr.nil? || address.preferred
        other_addr = address
      end
    end

    unless work_addr.nil?
      contact['businessAddress'] = {
        street: work_addr.street,
        city: work_addr.locality,
        state: work_addr.region,
        countryOrRegion: work_addr.country,
        postalCode: work_addr.postalcode
      }

      contact['officeLocation'] = work_addr.extended
    end

    unless home_addr.nil?
      contact['homeAddress'] = {
        street: home_addr.street,
        city: home_addr.locality,
        state: home_addr.region,
        countryOrRegion: home_addr.country,
        postalCode: home_addr.postalcode
      }
    end

    return if other_addr.nil?

    contact['otherAddress'] = {
      street: other_addr.street,
      city: other_addr.locality,
      state: other_addr.region,
      countryOrRegion: other_addr.country,
      postalCode: other_addr.postalcode
    }
  end

  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/BlockLength

  def add_phone_numbers(maker, numbers, type)
    numbers.each do |number|
      add_phone_number maker, number, type
    end
  end

  def add_phone_number(maker, number, type)
    return if number.nil?

    maker.add_tel(number) do |t|
      t.location = type
      t.capability = 'VOICE'
    end
  end

  def make_org_string(company, department)
    return '' if company.nil? && department.nil?

    "#{company || ''};#{department || ''}"
  end

  def vcard_to_graph(vcard)
    # A VCF file can have multiple contacts
    cards = Vcard::Vcard.decode(vcard)

    return if cards.nil? || cards.length <= 0

    contacts = []

    # Convert each entry in the VCF to a Graph contact
    cards.each do |card|
      contacts.push contact_from_card(card)
    end

    contacts
  end
end
# rubocop:enable Metrics/ModuleLength

# Extensions to the Vcard::Maker class to add new
# fields.
module Vcard
  class Vcard
    # Maker
    class Maker
      def add_assistant(assistant)
        # Custom field Outlook uses to store assistant name
        @card << ::Vcard::DirectoryInfo::Field.create('X-MS-ASSISTANT',
                                                      assistant.to_str)
      end

      def add_manager(manager)
        # Custom field Outlook uses to store manager name
        @card << ::Vcard::DirectoryInfo::Field.create('X-MS-MANAGER',
                                                      manager.to_str)
      end

      def add_im_address(im_address)
        # Custom field Outlook uses to store IM address
        @card << ::Vcard::DirectoryInfo::Field.create('X-MS-IMADDRESS',
                                                      im_address.to_str)
      end

      def add_categories(categories)
        category_string = categories.join(',')
        # Defined in http://www.ietf.org/rfc/rfc2426.txt
        @card << ::Vcard::DirectoryInfo::Field.create('CATEGORIES',
                                                      category_string)
      end

      def add_rev(time)
        # Date-time last revised
        @card << ::Vcard::DirectoryInfo::Field.create('REV', time)
      end

      def add_spouse(spouse)
        # Custom field Outlook uses for spouse name
        @card << ::Vcard::DirectoryInfo::Field.create('X-MS-SPOUSE',
                                                      spouse)
      end
    end
  end
end
