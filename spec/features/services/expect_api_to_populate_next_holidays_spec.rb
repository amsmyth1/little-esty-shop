require 'rails_helper'

RSpec.describe "Service Objects" do
  before :each do
    @merchant = create(:merchant)
  end

  describe "as a merchant" do
    describe "when I visit the discount index page Upcoming Holidays section " do
      it "utilizes an external API to diplay the name and date of the next 3 upcoming Holidays" do
        visit merchant_dashboard_index_path(@merchant)

        within '.merchant_discounts#holidays' do
          expect(page).to have_content("Upcoming Holidays")
          expect("Memorial Day").to appear_before("Independence Day", only_text: true)
          expect("Independence Day").to appear_before("Labour Day", only_text: true)
        end
      end
    end
  end
end
