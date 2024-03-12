# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[4.2]
  def change
    create_table :plans do |t|
      t.string :description, required: true, blank: false
      t.decimal :price, precision: 7, scale: 2, null: false
      t.integer :months, null: false
      t.integer :vat_rate, null: false
      t.boolean :is_active, null: false

      t.timestamps null: false
    end

    Plan.create(description: '1 mes', price: 5, months: 1, vat_rate: 21, is_active: true)
    Plan.create(description: '1 año', price: 50, months: 12, vat_rate: 21, is_active: true)
  end
end
