class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :merchants, through: :item
  has_many :discounts, through: :merchants

  enum status: [:pending, :packaged, :shipped]

  def self.search_for_quantity(invoiceid, itemid)
    select(:quantity)
    .find_by(invoice_id: invoiceid, item_id: itemid)
    .quantity
  end

  def self.find_all_by_invoice(invoice_id)
    where(invoice_id: invoice_id)
  end

  def item_name
    item.name
  end

  def merchant
    item.merchant
  end

  def invoice_date
    invoice.created_at_view_format
  end

  def discount_available

    merchant.clean_discounts

    self.discounts
    .where("discounts.threshold <= ?", self.quantity)
    .order("discounts.percentage desc")
    .limit(1)

  end

  def apply_discount
    if discount_available.count == 1
      self.update({discount_id: discount_available.first.id,
                      discount: discount_available.first.percentage})
    end
  end

  def apply_revenue
    apply_discount
    total_rev = (quantity * (unit_price * discount))
    self.update({revenue: total_rev})
  end
end
