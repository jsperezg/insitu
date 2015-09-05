class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :name, null: false, blank:  false
      t.string :note_for_invoice
      t.boolean :default, null: false, default: false

      t.timestamps null: false
    end
  end
end
