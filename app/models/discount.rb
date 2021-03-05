class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, through: :merchant

  validate :name
end
