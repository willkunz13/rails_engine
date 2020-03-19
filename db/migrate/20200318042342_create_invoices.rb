class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.bigint :customer_id
      t.bigint :merchant_id
      t.string :status
      t.string :created_at
      t.string :updated_at

      t.timestamps
    end
  end
end
