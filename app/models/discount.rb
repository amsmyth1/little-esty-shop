class Discount < ApplicationRecord
  belongs_to :merchant
  # has_many :invoice_items, through: :merchant

  validates_presence_of :name, :threshold, :percentage
  validates_numericality_of :threshold, :greater_than => 1
  validates_numericality_of :percentage, :greater_than => 0, :less_than => 1


  def self.max_id
    if Discount.first == nil
      1
    else
      maximum(:id) + 1
    end
  end
end
