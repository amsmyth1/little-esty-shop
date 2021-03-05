require 'rails_helper'

RSpec.describe "As a merchant" do
  before :each do
    skip
    @merchant = create(:merchant)
    @discount = create(:discount, merchant_id: @merchant.id)
  end
  describe "when viewing the merchant discount show page" do
    it "should display the discount's quantity threshold and percetage discount" do
      visit merchant_discount_path(@discount)


      expect(page).to have_content(@discount.name)
      expect(page).to have_content(@discount.threshold)
      expect(page).to have_content(@discount.percetage)
    end
  end
end
