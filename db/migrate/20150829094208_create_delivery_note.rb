# frozen_string_literal: true

class CreateDeliveryNote < ActiveRecord::Migration[4.2]
  def change
    create_table :delivery_notes do |t|
      t.string :number, length: 25, null: false, blank: false
      t.references :customer, index: true, foreign_key: true, null: false
      t.date :date, null: false

      t.timestamps null: false
    end
    add_index :delivery_notes, :number
  end
end
