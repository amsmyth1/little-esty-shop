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
      else
        expect(@holiday_info).to eq([])
      end
    end
  end

  describe "GithubService Clients" do
    it "can translate github endpoint" do
      lil_esty = GithubService.repo_object("https://api.github.com/repos/amsmyth1/little-esty-shop")

      answer_options = ["little-esty-shop", "validation error"]
      answer = answer_options.include?(lil_esty.repo_name)
      expect(answer).to eq(true)

      answer_options = [[], ["amsmyth1", "aschwartz1", "avjohnston", "BrianZanti", "abreaux26", "timomitchel", "scottalexandra"]]
      answer = answer_options.include?(lil_esty.contributors)

      expect(answer).to eq(true)
      expect(lil_esty.pull_count).to eq(1)
    end
  end

  describe "HolidayService Client" do
    it "can translate endpoint" do
      holidays = ApiService.get_info("https://date.nager.at/Api/v2/NextPublicHolidays/US")
      if holidays.count > 0
        expect(HolidayService.next_three_holidays).to eq(["Memorial Day on 2021-05-31", "Independence Day on 2021-07-05", "Labour Day on 2021-09-06"])
      else
        expect(HolidayService.next_three_holidays).to eq([])
      end
    end
  end
end
