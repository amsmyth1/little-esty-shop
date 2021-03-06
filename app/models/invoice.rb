class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  belongs_to :customer

  enum status: [:cancelled, :completed, :in_progress]

  def created_at_view_format
    created_at.strftime('%A, %B %d, %Y')
  end

  def self.all_invoices_with_unshipped_items
    joins(:invoice_items)
    .where('invoice_items.status = ?', 1)
    .distinct(:id)
    .order(:created_at)
  end

  def customer_full_name
    customer.full_name
  end

  def total_revenue
    invoice_items.apply_discount
    invoice_items.pluck(Arel.sql("sum(invoice_items.quantity * (invoice_items.unit_price * invoice_items.discount)) as total_revenue"))
  end

  def bulk_discount
     # Merchant.joins(:invoice_items).joins(:discounts)
     #
     #          .where('id = ?', self.merchant.id)
     #          .where('discount.threshold > invoice_items.quantity')
     #
     #  merchant.invoice_items

  end
end
