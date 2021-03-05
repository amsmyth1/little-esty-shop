require 'rails_helper'

RSpec.describe 'As a merchant' do
  before :each do
    set_up
  end
  describe 'when viewing the merchant discounts index page' do
    it 'should display all the merchants discounts' do
      visit merchant_discounts_path(@merchant)

      @merchant.discounts.each do |discount|
        within ".discount_info#discount-#{discount.id}" do
          expect(page).to have_content(discount.name)
          expect(page).to have_content(discount.threshold)
          expect(page).to have_content(discount.percentage)
        end
      end
    end
    it 'should link to each discount show page' do
      visit merchant_discounts_path(@merchant)
      within ".discount_info#discount-#{@discount_1.id}" do
        click_on("#{@discount_1.id}")
      end

      expect(current_path).to eq(merchant_discount_path(@merchant, @discount_1))
    end
    it 'should have a link to delete a discount' do
      visit merchant_discounts_path(@merchant)
      within ".discount_info#discount-#{@discount_1.id}" do
        click_on("Delete Discount")
      end
      expect(current_path).to eq(merchant_discounts_path(@merchant))
      expect(page).to_not have_content(@discount_1.name)
      expect(page).to_not have_content(@discount_1.id)
    end
    it 'should have a link to create a new discount' do
      visit merchant_discounts_path(@merchant)
      click_on("Create a New Discount")

      expect(current_path).to eq(new_merchant_discount_path(@merchant))
    end
  end

  def set_up
    @merchant = create(:merchant)
    @discount_1 = create(:discount, merchant_id: @merchant.id)
    @discount_2 = create(:discount, merchant_id: @merchant.id)
    @discount_3 = create(:discount, merchant_id: @merchant.id)
    @discount_4 = create(:discount, merchant_id: @merchant.id)
    @discount_5 = create(:discount, merchant_id: @merchant.id)
  end
end
