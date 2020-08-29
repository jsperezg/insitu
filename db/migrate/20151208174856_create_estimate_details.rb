# frozen_string_literal: true

class CreateEstimateDetails < ActiveRecord::Migration
  def change
    create_table :estimate_details do |t|
      t.references :estimate, index: true, foreign_key: true, null: false
      t.references :service, index: true, foreign_key: true, null: false
      t.string :description
      t.decimal :quantity, precision: 7, scale: 2, null: false
      t.decimal :price, precision: 7, scale: 2, null: false
      t.integer :discount, null: false, default: 0

      t.timestamps null: false
    end
  end
end
