require 'rails_helper'

RSpec.describe "As a merchant" do
  before :each do
    @merchant = create(:merchant)
    @discount = create(:discount, merchant_id: @merchant.id)
  end

  describe "when viewing the merchant discount edit page" do
    it "should have a populated form" do
      visit edit_merchant_discount_path(@merchant, @discount)

      expect(page).to have_content(@discount.name)
    end
    it "should update the record if the form is filled out correctly" do
      visit edit_merchant_discount_path(@merchant, @discount)

      fill_in(:threshold, with: 10)

      click_on("Update")

      expect(current_path).to eq(merchant_discount_path(@merchant, @discount))
      expect(page).to have_content("threshold: 10")
    end
    it "should display a flash message if the name is forgotten" do
      visit edit_merchant_discount_path(@merchant, @discount)

      fill_in "name", with: ""
      fill_in "threshold", with: 5
      fill_in "percentage", with: 0.50

      click_on "Update"

      expect(page).to have_content("Name cannot be blank")
    end
    it "should display a flash message if the threshold is 1 or less" do
      visit edit_merchant_discount_path(@merchant, @discount)

      fill_in "name", with: "SPEC test SPECIAL"
      fill_in "threshold", with: 0
      fill_in "percentage", with: 0.50

      click_on "Update"

      expect(page).to have_content("Threshold must be greater than 1")

      fill_in "name", with: "SPEC test SPECIAL"
      fill_in "threshold", with: 1
      fill_in "percentage", with: 0.50

      click_on "Update"

      expect(page).to have_content("Threshold must be greater than 1")
    end
    it "should display a flash message if the percetage is 0 or over 1" do
      visit edit_merchant_discount_path(@merchant, @discount)

      fill_in "name", with: "SPEC test SPECIAL"
      fill_in "threshold", with: 5
      fill_in "percentage", with: 0.00

      click_on "Update"

      expect(page).to have_content("Percentage must be between 0 and 1")
      fill_in "name", with: "SPEC test SPECIAL"
      fill_in "threshold", with: 5
      fill_in "percentage", with: 1.50

      click_on "Update"

      expect(page).to have_content("Percentage must be between 0 and 1")
    end
  end
end
