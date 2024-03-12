# frozen_string_literal: true

class CreateVats < ActiveRecord::Migration[4.2]
  def change
    create_table :vats do |t|
      t.string :label, null: false, blank: false, index: true
      t.integer :rate, null: false

      t.timestamps null: false
    end

    add_index :vats, :rate
  end
end
