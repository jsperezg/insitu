# frozen_string_literal: true

class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :code, length: 10, null: false, blank: false, index: true
      t.string :description, null: false, blank: false
      t.references :vat, index: true, foreign_key: false, null: false
      t.references :unit, index: true, foreign_key: false, null: false
      t.decimal :price, precision: 7, scale: 2, null: false

      t.timestamps null: false
    end
  end
end
