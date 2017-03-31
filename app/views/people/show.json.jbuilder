json.display_name @person.display_name

if @most_recent_incumbency.nil? || @most_recent_incumbency.house.name == 'House of Lords'
  json.full_title @person.full_title
  json.full_name @person.full_name unless @person.display_name == @person.full_name
end

json.status @person.statuses[:house_membership_status].join(' and ')

if @person.statuses[:house_membership_status].include?('Current MP')
  json.constituency @current_incumbency.constituency.name
end

if @current_party_membership && @current_incumbency
  json.party @current_party_membership.party.name
end

json.contact_points @current_incumbency.contact_points do |contact_point|
  json.email contact_point.email
  json.phone_number contact_point.phone_number
  json.postal_addresses contact_point.postal_addresses do |address|
    json.address address.full_address
  end
end

json.incumbencies_house_of_lords @house_incumbencies do |house_incumbency|
  json.start_date house_incumbency.start_date
  json.end_date house_incumbency.end_date
end

json.incumbencies_house_of_commons @seat_incumbencies do |seat_incumbency|
  json.constituency seat_incumbency.constituency.name
  json.start_date seat_incumbency.start_date
  json.end_date seat_incumbency.end_date
end
