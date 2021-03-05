class Discount < ApplicationRecord
  belongs_to :merchant
  # has_many :invoice_items, through: :merchant

  validates_presence_of :name, :threshold, :percentage
end
