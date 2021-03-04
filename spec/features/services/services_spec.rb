require 'rails_helper'

RSpec.describe "Service Objects" do
  def setup
  end
  describe "ApiService Object" do
    it "can translate endpoint to hash" do
      @holiday_info = ApiService.get_info("https://date.nager.at/Api/v2/NextPublicHolidays/US")
# binding.pry
      expect(@holiday_info.class).to eq(Array)
      expect(@holiday_info.count).to eq(10)
      expect(@holiday_info.first[:name]).to eq("Memorial Day")
      expect(@holiday_info.first[:date]).to eq("2021-05-31")

      # parsed[0..2].map do |holiday|
      #     holiday[:name]
      # end
    end
  end
  describe "HolidayService Object" do
    it "can translate endpoint to hash" do
      @holiday_info = ApiService.get_info("https://date.nager.at/Api/v2/NextPublicHolidays/US")

      expect(@holiday_info.class).to eq(Array)
      expect(HolidayService.next_three_holidays).to eq(["Memorial Day", "Independence Day", "Labour Day"])
    end
  end
end
