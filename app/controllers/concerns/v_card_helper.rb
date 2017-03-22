# Namespace for helper methods to generate a vcard.
module VCardHelper
  # Generates a vcard for the given contact point.
  #
  # @param [Grom::Node] contact_point a Grom::Node with type: http://id.ukpds.org/schema/ContactPoint.
  # @return [Vcard::Vcard] a vcard with person, postal address and contact details set.
  def create_vcard(contact_point)
    Vcard::Vcard::Maker.make2 do |maker|
      maker.add_name do |name|
        person_set(contact_point, name)
        postal_address_set(contact_point, maker)
        contacts_set(contact_point, maker)
      end
    end
  end

  # Sets the contact details of a vcard.
  #
  # @param [Grom::Node] contact_point a Grom::Node with type: http://id.ukpds.org/schema/ContactPoint.
  # @param [Vcard::Vcard::Maker] maker a Vcard builder.
  # @return [Vcard::Vcard::Maker] a Vcard maker with contact details set.
  def contacts_set(contact_point, maker)
    maker.add_email(contact_point.email) unless contact_point.email == ''
    maker.add_tel(contact_point.phone_number) unless contact_point.phone_number == ''
    maker.add_tel(contact_point.fax_number) { |f| f.location = 'fax' } unless contact_point.fax_number == ''
  end

  # Sets the postal address of a vcard.
  #
  # @param [Grom::Node] contact_point a Grom::Node with type: http://id.ukpds.org/schema/ContactPoint.
  # @param [Vcard::Vcard::Maker] maker a Vcard builder.
  # @return [Vcard::Vcard::Maker, Boolean] a Vcard maker with postal address set or false if the contact point has no postal addresses.
  def postal_address_set(contact_point, maker)
    return false if contact_point.postal_addresses.empty?
    address = contact_point.postal_addresses.first.full_address
    maker.add_addr do |addr|
      addr.street = address unless address == ''
    end
  end

  # Sets the person details of a vcard.
  #
  # @param [Grom::Node] contact_point a Grom::Node with type: http://id.ukpds.org/schema/ContactPoint.
  # @param [Object] name a Vcard::Name.
  # @return [Vcard::Vcard::Maker, Boolean] a Vcard maker with person details set or false if the contact point is not associated with a person.
  def person_set(contact_point, name)
    return false if contact_point.incumbency.nil? || contact_point.incumbency.member.nil?
    name.given = contact_point.incumbency.member.given_name
    name.family = contact_point.incumbency.member.family_name
  end
end
