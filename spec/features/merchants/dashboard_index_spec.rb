require 'rails_helper'

RSpec.describe 'As a merchant' do
  before :each do
    setup
  end

  describe 'When I visit my merchant dashboard (/merchant/merchant_id/dashboard)' do
    it 'I see the name of my merchant' do
      visit merchant_dashboard_index_path(@merchant)

      expect(current_path).to eq("/merchants/#{@merchant.id}/dashboard")

      expect(page).to have_content(@merchant.name)
    end

    it 'I see link to my merchant items index (/merchant/merchant_id/items)' do
      visit merchant_dashboard_index_path(@merchant)

      within(".nav") do
        expect(page).to have_link('My Items')
        click_link('My Items')
        expect(current_path).to eq(merchant_items_path(@merchant))
      end
    end

    it 'I see a link to my merchant invoices index (/merchant/merchant_id/invoices)' do
      visit merchant_dashboard_index_path(@merchant)

      within(".nav") do
        expect(page).to have_link('My Invoices')
        click_link('My Invoices')
        expect(current_path).to eq(merchant_invoices_path(@merchant))
      end
    end

    it 'I see top 5 customers full name' do
      visit merchant_dashboard_index_path(@merchant)

      expect(page).to have_content(@customer_1.full_name)
      expect(page).to have_content(@customer_2.full_name)
      expect(page).to have_content(@customer_3.full_name)
      expect(page).to have_content(@customer_4.full_name)
      expect(page).to have_content(@customer_5.full_name)

      expect(page).not_to have_content(@customer_6.full_name)
      expect(page).not_to have_content(@customer_7.full_name)
      expect(page).not_to have_content(@customer_8.full_name)
      expect(page).not_to have_content(@customer_9.full_name)
      expect(page).not_to have_content(@customer_10.full_name)
    end

    it 'I see number of purches next to each customer' do
      visit merchant_dashboard_index_path(@merchant)

      within("#customer-#{@customer_1.id}") do
        expect(page).to have_content(@customer_1.transaction_count)
      end

      within("#customer-#{@customer_2.id}") do
        expect(page).to have_content(@customer_2.transaction_count)
      end

      within("#customer-#{@customer_3.id}") do
        expect(page).to have_content(@customer_3.transaction_count)
      end

      within("#customer-#{@customer_4.id}") do
        expect(page).to have_content(@customer_4.transaction_count)
      end

      within("#customer-#{@customer_5.id}") do
        expect(page).to have_content(@customer_5.transaction_count)
      end
    end

    it 'I see a section for items ready to ship' do
      visit merchant_dashboard_index_path(@merchant)

      expect(page).to have_content("Items Ready to Ship")
      expect(page).to have_link("Invoice ##{@invoice_1.id}")
    end

    it 'I see a link to view all my discounts' do
      visit merchant_dashboard_index_path(@merchant)

      click_on("My Discounts")
      expect(current_path).to eq(merchant_discounts_path(@merchant))
    end
  end
  def setup
    @merchant = create(:merchant)

    @item = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)

    @customer_1 = create(:customer, first_name: "Ace")

    @invoice_1 = create(:invoice, customer_id: @customer_1.id, status: :completed)
    @invoice_2 = create(:invoice, customer_id: @customer_1.id)
    @invoice_3 = create(:invoice, customer_id: @customer_1.id)
    @invoice_4 = create(:invoice, customer_id: @customer_1.id)
    @invoice_5 = create(:invoice, customer_id: @customer_1.id)
    @invoice_6 = create(:invoice, customer_id: @customer_1.id)

    @invoice_item_1 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_1.id, status: :pending)
    @invoice_item_2 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_2.id)
    @invoice_item_3 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_3.id)
    @invoice_item_4 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_4.id)
    @invoice_item_5 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_5.id, status: :shipped)
    @invoice_item_6 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice_6.id, status: :shipped)

    @transaction_1 = create(:transaction, result: 1, invoice_id: @invoice_1.id)
    @transaction_2 = create(:transaction, result: 1, invoice_id: @invoice_2.id)
    @transaction_3 = create(:transaction, result: 1, invoice_id: @invoice_3.id)
    @transaction_4 = create(:transaction, result: 1, invoice_id: @invoice_4.id)
    @transaction_5 = create(:transaction, result: 1, invoice_id: @invoice_5.id)

    @customer_2 = create(:customer, first_name: "Eli")
    @invoice_21 = create(:invoice, customer_id: @customer_2.id)
    @invoice_22 = create(:invoice, customer_id: @customer_2.id)
    @invoice_23 = create(:invoice, customer_id: @customer_2.id)
    @invoice_24 = create(:invoice, customer_id: @customer_2.id)
    @invoice_25 = create(:invoice, customer_id: @customer_2.id)

    @invoice_item_21 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_21.id)
    @invoice_item_22 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_22.id)
    @invoice_item_23 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_23.id)
    @invoice_item_24 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_24.id)
    @invoice_item_25 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_25.id)

    @transaction_21 = create(:transaction, result: 0, invoice_id: @invoice_21.id)
    @transaction_22 = create(:transaction, result: 0, invoice_id: @invoice_22.id)
    @transaction_23 = create(:transaction, result: 0, invoice_id: @invoice_23.id)
    @transaction_24 = create(:transaction, result: 1, invoice_id: @invoice_24.id)
    @transaction_25 = create(:transaction, result: 0, invoice_id: @invoice_25.id)

    @customer_3 = create(:customer, first_name: "Danny")
    @invoice_31 = create(:invoice, customer_id: @customer_3.id)
    @invoice_32 = create(:invoice, customer_id: @customer_3.id)
    @invoice_33 = create(:invoice, customer_id: @customer_3.id)
    @invoice_34 = create(:invoice, customer_id: @customer_3.id)
    @invoice_35 = create(:invoice, customer_id: @customer_3.id)

    @invoice_item_31 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_31.id)
    @invoice_item_32 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_32.id)
    @invoice_item_33 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_33.id)
    @invoice_item_34 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_34.id)
    @invoice_item_35 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_35.id)

    @transaction_31 = create(:transaction, result: 0, invoice_id: @invoice_31.id)
    @transaction_32 = create(:transaction, result: 1, invoice_id: @invoice_32.id)
    @transaction_33 = create(:transaction, result: 1, invoice_id: @invoice_33.id)
    @transaction_34 = create(:transaction, result: 0, invoice_id: @invoice_34.id)
    @transaction_35 = create(:transaction, result: 0, invoice_id: @invoice_35.id)

    @customer_4 = create(:customer, first_name: "Cate")
    @invoice_41 = create(:invoice, customer_id: @customer_4.id)
    @invoice_42 = create(:invoice, customer_id: @customer_4.id)
    @invoice_43 = create(:invoice, customer_id: @customer_4.id)
    @invoice_44 = create(:invoice, customer_id: @customer_4.id)
    @invoice_45 = create(:invoice, customer_id: @customer_4.id)

    @invoice_item_41 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_41.id)
    @invoice_item_42 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_42.id)
    @invoice_item_43 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_43.id)
    @invoice_item_44 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_44.id)
    @invoice_item_45 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_45.id)

    @transaction_41 = create(:transaction, result: 1, invoice_id: @invoice_41.id)
    @transaction_42 = create(:transaction, result: 1, invoice_id: @invoice_42.id)
    @transaction_43 = create(:transaction, result: 1, invoice_id: @invoice_43.id)
    @transaction_44 = create(:transaction, result: 0, invoice_id: @invoice_44.id)
    @transaction_45 = create(:transaction, result: 0, invoice_id: @invoice_45.id)

    @customer_5 = create(:customer, first_name: "Bob")
    @invoice_51 = create(:invoice, customer_id: @customer_5.id)
    @invoice_52 = create(:invoice, customer_id: @customer_5.id)
    @invoice_53 = create(:invoice, customer_id: @customer_5.id)
    @invoice_54 = create(:invoice, customer_id: @customer_5.id)
    @invoice_55 = create(:invoice, customer_id: @customer_5.id)

    @invoice_item_51 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_51.id)
    @invoice_item_52 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_52.id)
    @invoice_item_53 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_53.id)
    @invoice_item_54 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_54.id)
    @invoice_item_55 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_55.id)

    @transaction_51 = create(:transaction, result: 1, invoice_id: @invoice_51.id)
    @transaction_52 = create(:transaction, result: 1, invoice_id: @invoice_52.id)
    @transaction_53 = create(:transaction, result: 1, invoice_id: @invoice_53.id)
    @transaction_54 = create(:transaction, result: 1, invoice_id: @invoice_54.id)
    @transaction_55 = create(:transaction, result: 0, invoice_id: @invoice_55.id)

    @customer_6 = create(:customer)
    @customer_7 = create(:customer)
    @customer_8 = create(:customer)
    @customer_9 = create(:customer)
    @customer_10 = create(:customer)
  end
end
