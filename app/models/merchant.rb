class Merchant < ApplicationRecord
  has_many :items
  has_many :discounts
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  enum status: { disabled: 0, enabled: 1 }

  def self.by_status(status)
    return [] unless statuses.include?(status)
    where(status: status)
  end

  def self.top_five_by_revenue
    joins(:transactions)
      .select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as merchant_revenue')
      .where('transactions.result = ?', Transaction.results[:success])
      .group(:id)
      .order('merchant_revenue desc')
      .limit(5)
  end

  def total_revenue
    revenue_snippet = Arel.sql('sum(invoice_items.unit_price * invoice_items.quantity)')

    transactions.where('transactions.result = ?', Transaction.results[:success])
                .pluck(revenue_snippet)
                .first
  end

  def best_day
    revenue_snippet = Arel.sql('sum(invoice_items.unit_price * invoice_items.quantity)')
    order_by_revenue_snippet = Arel.sql(revenue_snippet + ' desc')

    invoices.select(:created_at, revenue_snippet)
            .joins(:transactions)
            .where('transactions.result = ?', Transaction.results[:success])
            .group(:created_at)
            .order(order_by_revenue_snippet, created_at: :desc)
            .limit(1)
            .pluck(:created_at)
            .first
  end

  def top_five_customers
    customers.all_successful_transactions_by_customer_count
  end

  def invoice_items_ready
    invoice_items.where.not(status: :shipped)
                 .joins(:invoice)
                 .where('invoices.status = ?', Invoice.statuses[:completed])
                 .order('invoices.created_at')
  end

  def clean_discounts
    #eliminates duplicate threshold discounts so only the larger percentage remains
    repeated_thresholds = discounts
                    .select("threshold, count(threshold)")
                    .group('discounts.threshold')
                    .having("count(threshold) > ?", 1)
                    .pluck(:threshold)
    repeated_thresholds.each do |repeated_threshold|
      count = discounts.where(threshold: repeated_threshold).size
      self.discounts
        .where(threshold: repeated_threshold)
        .order(:percentage)
        .limit(count - 1)
        .destroy_all
    end
  end
end 
  # def clean_discounts
  #   #eliminates duplicate threshold discounts so only the larger percentage remains
  #   binding.pry
  #   repeated_thresholds = discounts
  #                   .select("threshold, count(threshold)")
  #                   .group('discounts.threshold')
  #                   .having("count(threshold) > ?", 1)
  #                   .pluck(:threshold)
  #   repeated_thresholds.each do |repeated_threshold|
  #     binding.pry
  #     count = discounts.where(threshold: repeated_threshold)
  #     self.discounts
  #       .where(threshold: repeated_threshold)
  #       .order(:percentage)
  #       .limit(count - 1)
  #       .destroy_all
  #   end
  # end

  # def discounts_by_largest_threshold
  #   clean_discounts
  #   discounts
  #     .order(threshold: :desc)
  #     .select(:threshold, :percentage)
  # end
  #
  # def discount_threshold_ranges
  #   thresholds = discounts_by_largest_threshold
  #   binding.pry
  #   ranges = []
  #   thresholds.each_with_index do |threshold, index|
  #     binding.pry
  #     ranges << [threshold, threshold_lower_range(threshold, index)]
  #   end
  #   ranges
  # end
  #
  # def threshold_lower_range(threshold, index)
  #   thresholds = discounts.order(threshold: :desc).pluck(:threshold)
  #   next_threshold = thresholds[(index + 1)]
  #   if next_threshold == nil
  #     0
  #   else
  #   threshold_lower_range = next_threshold + 1
  #   end
  # end

  # def discount_threshold_ranges
  #   thresholds = discounts.order(threshold: :desc).pluck(:threshold)
  #   ranges = []
  #   thresholds.each_with_index do |threshold, index|
  #     ranges << [threshold, threshold_lower_range(threshold, index)]
  #   end
  #   ranges
  # end
  #
  # def threshold_lower_range(threshold, index)
  #   thresholds = discounts.order(threshold: :desc).pluck(:threshold)
  #   next_threshold = thresholds[(index + 1)]
  #   if next_threshold == nil
  #     0
  #   else
  #   threshold_lower_range = next_threshold + 1
  #   end
  # end
