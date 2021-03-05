require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationhips' do
    it { should belong_to :merchant }
    # it { should have_many(:invoice_items).through(:merchant)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:threshold) }
    it { should validate_presence_of(:percentage) }
  end

  describe 'class methods' do
  end

  describe 'instance methods' do
  end
end
