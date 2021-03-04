require 'rails_helper'

RSpec.describe "Service Objects" do
  def setup
    @holiday_info = ApiService.get_info('https://date.nager.at/Api/v2/NextPublicHolidays/US')
  end

  describe "as a merchant" do
    describe "when I visit the discount index page Upcoming Holidays section " do
      it "utilizes an external API to diplay the name and date of the next 3 upcoming Holidays" do


        expect("Memorial Day").to appear_before("Independence Day", only_text: true)
        expect("Independence Day").to appear_before("Labour Day", only_text: true)
      end
    end
  end
end
