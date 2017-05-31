module ViewHelper
  # this method changes the house membership status array to capitalize only the first status
  # eg 'Member of the House of Lords and former MP' rather than 'Member of the Hose of Lords and Former MP'
  def convert_house_membership_status(statuses)
    statuses.each_with_index do |status, index|
      if index != 0
        status[0] = status[0].downcase
      end
    end
  end

end
