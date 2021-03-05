class HolidayService < ApiService

  def self.next_three_holidays
    holidays = get_info("https://date.nager.at/Api/v2/NextPublicHolidays/US")
    if holidays != []
      next_three_holidays = holidays[0..2]
      next_three_holidays.map do |holiday|
        "#{holiday[:name]} on #{holiday[:date]}"
      end
    end
  end
end
