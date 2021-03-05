require 'rails_helper'

RSpec.describe 'As a merchant' do
  before :each do
    @merchant = create(:merchant)
  end
  describe 'when viewing the merchant discounts new page' do
    it 'should have a link from merchant index to create a new discount' do
      visit merchant_discounts_path(@merchant)
      click_on("Create a New Discount")

      expect(current_path).to eq(new_merchant_discount_path(@merchant))
    end
    it 'should create a discount when form is filled out correctly' do
      visit new_merchant_discount_path(@merchant)

      fill_in :name, with: "SPEC test SPECIAL"
      fill_in :threshold, with: 5
      fill_in :percentage, with: 0.50

      click_on "Submit"

      expect(current_path).to eq(merchant_discounts_path(@merchant))
      expect(page).to have_content("SPEC test SPECIAL")
    end
    it 'should send a flash message when name is forgotten' do
      visit new_merchant_discount_path(@merchant)

      fill_in :name, with: ""
      fill_in :threshold, with: 5
      fill_in :percentage, with: 0.50

      click_on "Submit"

      expect(current_path).to eq(new_merchant_discount_path(@merchant))
      expect(page).to have_content("The name cannot be blank")
    end
    it 'should send a flash message when name is threshold is 1 or less' do
      visit new_merchant_discount_path(@merchant)

      fill_in :name, with: "SPEC test SPECIAL"
      fill_in :threshold, with: 0
      fill_in :percentage, with: 0.50

      click_on "Submit"

      expect(current_path).to eq(new_merchant_discount_path(@merchant))
      expect(page).to have_content("The threshold must be greater than 1")

      fill_in :name, with: "SPEC test SPECIAL"
      fill_in :threshold, with: 1
      fill_in :percentage, with: 0.50

      click_on "Submit"

      expect(current_path).to eq(new_merchant_discount_path(@merchant))
      expect(page).to have_content("The threshold must be greater than 1")
    end
    it 'should send a flash message when percentage is 0 or greater than 1' do
      visit new_merchant_discount_path(@merchant)

      fill_in :name, with: "SPEC test SPECIAL"
      fill_in :threshold, with: 5
      fill_in :percentage, with: 0.00

      click_on "Submit"

      expect(current_path).to eq(new_merchant_discount_path(@merchant))
      expect(page).to have_content("The percentage discount must be greater than 0.")
      fill_in :name, with: "SPEC test SPECIAL"
      fill_in :threshold, with: 5
      fill_in :percentage, with: 1.50

      click_on "Submit"

      expect(current_path).to eq(new_merchant_discount_path(@merchant))
      expect(page).to have_content("The percentage discount must be less than 100% (or 1).")
    end
  end
end
