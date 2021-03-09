class AddColumnsToInvoiceItem < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_items, :discount_id, :integer
    add_column :invoice_items, :discount, :decimal, default: 1
    add_column :invoice_items, :revenue, :decimal
  end
end
