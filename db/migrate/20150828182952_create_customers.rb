class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name, null: false, blank: false
      t.string :tax_id, length: 25
      t.string :billing_serie, length: 1
      t.integer :billing_tax
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email, length: 250

      t.timestamps null: false
    end
  end
end
