require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationhips' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).through(:merchant)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:threshold) }
    it { should validate_presence_of(:percentage) }
    it { should validate_numericality_of(:percentage) }
    it { should validate_numericality_of(:threshold) }

    it "should not dave a record with a threshold of 1" do
      @merchant = create(:merchant)
      @discount = @merchant.discounts.new({name: "Name", threshold: 1, percentage: 0.7})

      expect(@discount.save).to eq (false)
    end
    it "should not dave a record with a threshold of 0" do
      @merchant = create(:merchant)
      @discount = @merchant.discounts.new({name: "Name", threshold: 0, percentage: 0.7})

      expect(@discount.save).to eq (false)
    end
    it "should not dave a record with a percentage greater than 1" do
      @merchant = create(:merchant)
      @discount = @merchant.discounts.new({name: "Name", threshold: 10, percentage: 1.7})

      expect(@discount.save).to eq (false)
    end
    it "should not dave a record with a percentage less than 0" do
      @merchant = create(:merchant)
      @discount = @merchant.discounts.new({name: "Name", threshold: 10, percentage: -0.2})

      expect(@discount.save).to eq (false)
    end
    it "should not dave a record with a percentage of 0" do
      @merchant = create(:merchant)
      @discount = @merchant.discounts.new({name: "Name", threshold: 10, percentage: 0})

      expect(@discount.save).to eq (false)
    end
  end
end
