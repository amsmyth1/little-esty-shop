class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, through: :merchant

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

#   def items_applicable_for_discount(merchant_id)
#     Discount
#         .joins(:invoice_items)
#         .select("discounts.*, invoice_items.invoice_id")
#         .group("invoice_items.invoice_id", :threshold, :percentage, :id)
#         .where("invoice_items.quantity > discounts.threshold")
# Discount
#     .joins(:invoice_items)
#     .where(merchant_id: merchant_id)
#     .select("discounts.*, invoice_items.invoice_id")
#     .group("invoice_items.invoice_id")
#     .group("invoice_items.invoice_id")
#     .where("invoice_items.quantity > max(discounts.threshold)")
#   merchant
#     .discounts
#     .joins(:invoice_items)
#     .select("invoice_items.invoice_id, invoice_items.id, invoice_items.item_id")
#     .group("invoice_items.invoice_id, invoice_items.id, invoice_items.item_id")
# end
end
