require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationhips' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).through(:merchant)}
  end

  describe 'validations' do
    # it { should validate_presence_of(:name) }
    # it { should define_enum_for(:status).with_values(disabled: 0, enabled: 1) }
  end

  describe 'class methods' do
  end

  describe 'instance methods' do
  end
end
