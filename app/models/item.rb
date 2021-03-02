class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant

  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 15, maximum: 500 }
  validates :unit_price, numericality: true

  enum status: [:disabled, :enabled]

  def self.enabled
    where(status: :enabled)
    .order(:id)
  end

  def self.disabled
    where(status: :disabled)
    .order(:id)
  end

  def self.max_id
    maximum(:id) + 1
  end

  def best_day
    invoices.joins(:invoice_items)
            .select('invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
            .where('invoice_items.status = 2')
            .group('invoices.created_at')
            .order('total_revenue desc')
            .first
            .created_at
            .strftime('%m/%d/%Y')
  end
end
