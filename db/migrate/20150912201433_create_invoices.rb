class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :organization, index: true
      t.date :period_start
      t.date :period_end
      t.integer :total
      t.float :dyno_units

      t.timestamps
    end
  end
end
