class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :threshold
      t.decimal :percentage, precision: 5, scale: 2

      t.timestamps
    end
  end
end
