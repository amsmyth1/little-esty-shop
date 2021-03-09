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

  # def merchant_with_no_discount
  #   invoice_items.joins(:merchants).select("merchants.id").group("merchants.id").pluck("merchants.id")
  # end

  def total_revenue
    (Invoice.total_revenue_with_discounts_applicable(self.id).to_f) +
    (Invoice.total_revenue_with_no_discounts_applicable(self.id).to_f +
    (Invoice.total_revenue_with_no_merchant_discounts(self.id)).to_f)
  end

  def self.total_revenue_with_discounts_applicable(invoice_id)
    a = find_by_sql("
      SELECT invoice_id, sum(quantity_ordered * unit_price * (1 - best_discount)) as revenue_with_discount
      FROM (
      	SELECT
      		invoice_items.invoice_id as invoice_id,
          invoice_items.quantity as quantity_ordered,
          count(discounts) as discounts_eligible,
          invoice_items.unit_price,
          max(discounts.percentage) as best_discount
        FROM discounts
      	INNER JOIN items ON items.merchant_id = discounts.merchant_id
      	INNER JOIN invoice_items ON invoice_items.item_id = items.id
      	WHERE invoice_items.quantity >= discounts.threshold AND invoice_items.invoice_id = #{invoice_id}
      	GROUP BY invoice_items.id
            )
      	AS revenue
        GROUP BY invoice_id"
            ).pluck('revenue_with_discount').first
  end

  def self.total_revenue_with_no_discounts_applicable(invoice_id)
    a = find_by_sql("
      SELECT sum(regular_revenue) as total_regular_revenue
      FROM
        (
        SELECT
          invoice_items.invoice_id as invoice_id,
  		     invoice_items.quantity * invoice_items.unit_price as regular_revenue
  		   FROM discounts
  		  INNER JOIN items ON items.merchant_id = discounts.merchant_id
  			INNER JOIN invoice_items ON invoice_items.item_id = items.id
        WHERE invoice_items.invoice_id = #{invoice_id}
  			GROUP BY invoice_items.id
  			HAVING invoice_items.quantity < MIN(discounts.threshold)
        ) as reg_rev
      GROUP BY invoice_id"
      ).pluck('total_regular_revenue').first
  end

  def self.total_revenue_with_no_merchant_discounts(invoice_id)
    a = find_by_sql("
      SELECT invoice_id, sum(quantity* price) as revenue_without_merchant_discounts
        FROM (
        	SELECT
        		invoice_items.id as ii_id,
        		invoice_items.invoice_id as invoice_id,
        		invoice_items.unit_price as price,
        		invoice_items.quantity as quantity,
        		count(discounts) as available_discounts
        	FROM invoice_items
        	LEFT JOIN items ON items.id = invoice_items.item_id
        	LEFT JOIN discounts ON items.merchant_id = discounts.merchant_id
          WHERE invoice_id = #{invoice_id}
        	GROUP BY ii_id
        	HAVING count(discounts) = 0
        	) as merchants_with_no_discounts
        GROUP BY invoice_id
          ")
    if a == []
      0
    else
      a.pluck('revenue_without_merchant_discounts').first
    end
  end
end
