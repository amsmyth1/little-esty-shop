class RemoveColumnsFromInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :invoice_items, :revenue, :decimal
    remove_column :invoice_items, :discount_id, :integer
    remove_column :invoice_items, :discount, :decimal
  end
end
