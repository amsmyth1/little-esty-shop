require 'rails_helper'

RSpec.describe "Service Clients" do
  describe "ApiService Clients" do
    it "can translate endpoint to hash" do
      @holiday_info = ApiService.get_info("https://date.nager.at/Api/v2/NextPublicHolidays/US")
      if !@holiday_info.nil?
        expect(@holiday_info.class).to eq(Array)
        expect(@holiday_info.count).to eq(10)
        expect(@holiday_info.first[:name]).to eq("Memorial Day")
        expect(@holiday_info.first[:date]).to eq("2021-05-31")
      end
    end
  end

  describe "HolidayService Client" do
    it "can translate endpoint" do
      holidays = ApiService.get_info("https://date.nager.at/Api/v2/NextPublicHolidays/US")
      if holidays.count > 0
        expect(HolidayService.next_three_holidays).to eq(["Memorial Day on 2021-05-31", "Independence Day on 2021-07-05", "Labour Day on 2021-09-06"])
      end
    end
  end
end
