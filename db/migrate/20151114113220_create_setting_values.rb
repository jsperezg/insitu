# frozen_string_literal: true

class CreateSettingValues < ActiveRecord::Migration[4.2]
  def change
    create_table :setting_values do |t|
      t.integer :value_i
      t.string :value_s
      t.boolean :value_b
      t.date :value_d

      t.references :setting_key, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
