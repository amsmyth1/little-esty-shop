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

  def discount
    quantity = self.quantity
     discount_id = discounts
                      .where("#{quantity} >= discounts.threshold")
                      .order(percentage: :desc)
                      .limit(1)
                      .pluck(:id).first
    # find_by_sql("
    #   SELECT *
    #   FROM discounts
    #   INNER JOIN items ON items.merchant_id = discounts.merchant_id
    #   INNER JOIN invoice_items ON invoice_items.item_id = items.id
    #   WHERE #{quantity} >= discounts.threshold AND invoice_items.id = #{self.id}
    #   ORDER BY discounts.percentage desc
    #   limit 1
    #   ")
    if discount_id == [] or discount_id == nil
      []
    else
      Discount.find(discount_id)
    end
  end
end
