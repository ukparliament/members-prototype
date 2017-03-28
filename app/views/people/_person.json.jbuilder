json.name person.display_name
json.status person.statuses[:house_membership_status].join(' and ')

if person.statuses[:house_membership_status].include?('Current MP') && !person.seat_incumbencies.select(&:current?).empty?
  json.constituency person.seat_incumbencies.select(&:current?).first.constituency.name
end

unless person.party_memberships.select(&:current?).empty?
  json.party person.party_memberships.select(&:current?).first.party.name
end
