require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationhips' do
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
    it { should belong_to :customer }
  end

  describe 'instance methods' do
    describe '#status_view_format' do
      it "cleans up statuses so they are capitalize and have no symbols on view" do
        set_up
        invoice_a = create(:invoice, status: Invoice.statuses[:cancelled])
        invoice_b = create(:invoice, status: Invoice.statuses[:completed])
        invoice_c = create(:invoice, status: Invoice.statuses[:in_progress])

        expect(invoice_a.status_view_format).to eq("Cancelled")
        expect(invoice_b.status_view_format).to eq("Completed")
        expect(invoice_c.status_view_format).to eq("In Progress")
      end
    end

    describe '#created_at_view_format' do
      it "cleans up statuses so they are capitalize and have no symbols on view" do
        invoice_a = create(:invoice, created_at: Time.new(2021, 2, 24))

        expect(invoice_a.created_at_view_format).to eq("Wednesday, February 24, 2021")
      end
    end

    describe '#customer_full_name' do
      it 'returns customers full name' do
        set_up
        expect(@invoice_1.customer_full_name).to eq(@customer_1.full_name)
      end
    end

    describe '#total_revenue' do
      it 'returns total revenue from a specific invoice' do
        set_up
        expect('%.2f' % @invoice_1.total_revenue).to eq('30.00')
      end
    end
  end

  describe 'class methods' do
    describe '::all_invoices_with_unshipped_items' do
      it 'returns all invoices with unshipped items' do
        set_up

        expect(Invoice.all_invoices_with_unshipped_items).to eq([@invoice_1, @invoice_21])
      end
    end
    describe '#total_revenue, ::total_revenue_with_discounts_applicable/no_discounts_applicable' do
      it "calculates the total when no items are eligible for discount (examples 1)" do
        merchant = create(:merchant)
        merchant = create(:merchant)
        discount_1 = create(:discount, threshold: 5, percentage: 0.05, merchant_id: merchant.id)
        discount_2 = create(:discount, threshold: 10, percentage: 0.10, merchant_id: merchant.id)
        discount_3 = create(:discount, threshold: 20, percentage: 0.20, merchant_id: merchant.id)
        item = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        item3 = create(:item, merchant_id: merchant.id)
        item4 = create(:item, merchant_id: merchant.id)
        item5 = create(:item, merchant_id: merchant.id)
        customer_1 = create(:customer, first_name: "Ace")
        invoice_1 = create(:invoice, customer_id: customer_1.id, status: :completed)
        invoice_item_1 = create(:invoice_item, item_id: item.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 100) #no discount
        invoice_item_2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 100) #no discount
        invoice_item_3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 100) #no discount
        invoice_item_5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 100) #no discount


        expect(Invoice.total_revenue_with_discounts_applicable(invoice_1.id).to_f).to eq(0.00)
        expect(Invoice.total_revenue_with_no_discounts_applicable(invoice_1.id).to_f).to eq(400)
        expect(invoice_1.total_revenue.to_f).to eq(400)
      end
      it "calculates discounts for invoices with items that have no discount and different discounts (examples 2 and 3)" do
        merchant = create(:merchant)
        merchant = create(:merchant)
        discount_1 = create(:discount, threshold: 5, percentage: 0.05, merchant_id: merchant.id)
        discount_2 = create(:discount, threshold: 10, percentage: 0.10, merchant_id: merchant.id)
        discount_3 = create(:discount, threshold: 20, percentage: 0.20, merchant_id: merchant.id)
        item = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        item3 = create(:item, merchant_id: merchant.id)
        item4 = create(:item, merchant_id: merchant.id)
        item5 = create(:item, merchant_id: merchant.id)
        customer_1 = create(:customer, first_name: "Ace")
        invoice_1 = create(:invoice, customer_id: customer_1.id, status: :completed)
        invoice_item_1 = create(:invoice_item, item_id: item.id, invoice_id: invoice_1.id, quantity: 5, unit_price: 100) #apply discount 1
        invoice_item_2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice_1.id, quantity: 10, unit_price: 100) #apply discount 2
        invoice_item_3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice_1.id, quantity: 20, unit_price: 100) #apply discount 3
        invoice_item_5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 100) #no discount

        answer = (5 * 100 * 0.95) + (10 * 100 * 0.90) + (20 * 100 * 0.80) + 100

        expect(Invoice.total_revenue_with_discounts_applicable(invoice_1.id).to_f).to eq(answer - 100)
        expect(Invoice.total_revenue_with_no_discounts_applicable(invoice_1.id).to_f).to eq(100)
        expect(invoice_1.total_revenue.to_f).to eq(answer)
      end
      it "discounts the greatest percentage available for items that clear multiple discount thresholds (example 4)" do
        merchant = create(:merchant)
        discount_1 = create(:discount, threshold: 5, percentage: 0.5, merchant_id: merchant.id)
        discount_2 = create(:discount, threshold: 5, percentage: 0.10, merchant_id: merchant.id)
        discount_3 = create(:discount, threshold: 10, percentage: 0.10, merchant_id: merchant.id)
        discount_4 = create(:discount, threshold: 15, percentage: 0.20, merchant_id: merchant.id)
        item = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        item3 = create(:item, merchant_id: merchant.id)
        item4 = create(:item, merchant_id: merchant.id)

        customer_1 = create(:customer, first_name: "Ace")
        invoice_1 = create(:invoice, customer_id: customer_1.id, status: :completed)
        invoice_item_1 = create(:invoice_item, item_id: item.id, invoice_id: invoice_1.id, quantity: 5, unit_price: 100) #apply discount_1
        invoice_item_2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice_1.id, quantity: 10, unit_price: 200) #apply discount_1
        invoice_item_3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice_1.id, quantity: 15, unit_price: 300) #apply discount_1
        invoice_item_4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 400) #no discount

        answer = (5 * 100 * (1- 0.50)).to_f
        answer2 = (10 * 200 * (1- 0.50)).to_f
        answer3 = (15 * 300 * (1- 0.50)).to_f
        answer4 = (1 * 400).to_f
        answer_total_rev = (answer + answer2 + answer3 + answer4)


        expect(Invoice.total_revenue_with_discounts_applicable(invoice_1.id).to_f).to eq((answer + answer2 + answer3))
        expect(Invoice.total_revenue_with_no_discounts_applicable(invoice_1.id).to_f).to eq(answer4)
        expect(invoice_1.total_revenue).to eq(answer_total_rev)
      end
      it "calculates discounts for invoices with multiple vendor items (example 5)" do
        merchant = create(:merchant)
        merchant2 = create(:merchant)
        discount_1 = create(:discount, threshold: 5, percentage: 0.05, merchant_id: merchant.id)
        discount_2 = create(:discount, threshold: 10, percentage: 0.10, merchant_id: merchant.id)
        discount_3 = create(:discount, threshold: 5, percentage: 0.10, merchant_id: merchant2.id)
        discount_4 = create(:discount, threshold: 10, percentage: 0.20, merchant_id: merchant2.id)
        item = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        item3 = create(:item, merchant_id: merchant2.id)
        item4 = create(:item, merchant_id: merchant2.id)
        item5 = create(:item, merchant_id: merchant2.id)
        customer_1 = create(:customer, first_name: "Ace")
        invoice_1 = create(:invoice, customer_id: customer_1.id, status: :completed)
        invoice_item_1 = create(:invoice_item, item_id: item.id, invoice_id: invoice_1.id, quantity: 5, unit_price: 100) #apply discount 1, merchant
        invoice_item_2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice_1.id, quantity: 10, unit_price: 100) #apply discount 2, merchant
        invoice_item_3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice_1.id, quantity: 5, unit_price: 100) #apply discount 3, merchant2
        invoice_item_4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice_1.id, quantity: 10, unit_price: 100) #apply discount 4, merchant2
        invoice_item_5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 100) #no discount, merchant2

        answer = (5 * 100 * 0.95) + (10 * 100 * 0.90) + (5 * 100 * 0.90) + (10 * 100 * 0.80) + 100

        expect(Invoice.total_revenue_with_discounts_applicable(invoice_1.id).to_f).to eq(answer - 100)
        expect(Invoice.total_revenue_with_no_discounts_applicable(invoice_1.id).to_f).to eq(100)
        expect(invoice_1.total_revenue.to_f).to eq(answer)
      end
    end
  end
  def set_up
    @merchant = create(:merchant)

    @item_1 = create(:item, merchant_id: @merchant.id)
    @item_2 = create(:item, merchant_id: @merchant.id)
    @item_3 = create(:item, merchant_id: @merchant.id)

    @customer_1 = create(:customer, first_name: "Ace")
    @customer_2 = create(:customer, first_name: "Eli")
    @customer_3 = create(:customer)
    #customer_1 related vars
    @invoice_1 = create(:invoice, customer_id: @customer_1.id)
    @invoice_2 = create(:invoice, customer_id: @customer_1.id)
    @invoice_3 = create(:invoice, customer_id: @customer_1.id)
    @transaction_1 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_1.id)
    @transaction_2 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_2.id)
    @ii_1 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id, status: InvoiceItem.statuses[:packaged], quantity: 5, unit_price: 1.00)
    @ii_2 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_2.id, status: InvoiceItem.statuses[:shipped], quantity: 5, unit_price: 2.00)
    @ii_3 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_3.id, status: InvoiceItem.statuses[:shipped], quantity: 5, unit_price: 5.00)
    #customer_2 related vars
    @invoice_4 = create(:invoice, customer_id: @customer_2.id)
    @invoice_5 = create(:invoice, customer_id: @customer_2.id)
    @invoice_21 = create(:invoice, customer_id: @customer_2.id)
    @invoice_22 = create(:invoice, customer_id: @customer_2.id)
    @transaction_21 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_21.id)
    @transaction_22 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_22.id)
    @ii_21 = create(:invoice_item, invoice_id: @invoice_21.id, status: InvoiceItem.statuses[:packaged])
    #customer_3 related vars
    @invoice_31 = create(:invoice, customer_id: @customer_3.id)
    @invoice_32 = create(:invoice, customer_id: @customer_3.id)
    @transaction_31 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_31.id)
    @transaction_32 = create(:transaction, result: Transaction.results[:success], invoice_id: @invoice_32.id)
    @ii_31 = create(:invoice_item, invoice_id: @invoice_31.id, status: InvoiceItem.statuses[:shipped])
  end
end
