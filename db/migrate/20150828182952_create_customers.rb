# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[4.2]
  def change
    create_table :customers do |t|
      t.string :name, null: false, blank: false
      t.string :tax_id, length: 25
      t.string :billing_serie, length: 1
      t.integer :irpf
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email, length: 250
      t.string :address
      t.string :city
      t.string :postal_code, length: 25
      t.string :state
      t.string :country

      t.timestamps null: false
    end
  end
end
