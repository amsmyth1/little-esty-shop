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

      # parsed[0..2].map do |holiday|
      #     holiday[:name]
      # end
    end
  end

  describe "GithubService Clients" do
    it "can translate github endpoint" do
      lil_esty = GithubService.repo_object("https://api.github.com/repos/amsmyth1/little-esty-shop")

      answer_options = ["little-esty-shop", "validation error"]
      answer = answer_options.include?(lil_esty.repo_name)
      expect(answer).to eq(true)
      expect(lil_esty.contributors).to eq([])
      expect(lil_esty.pull_count).to eq(1)
    end
  end

  describe "HolidayService Client" do
    it "can translate endpoint to hash" do
      @holiday_info = ApiService.get_info("https://date.nager.at/Api/v2/NextPublicHolidays/US")

      expect(@holiday_info.class).to eq(Array)
      expect(HolidayService.next_three_holidays).to eq(["Memorial Day", "Independence Day", "Labour Day"])
    end
  end
end
