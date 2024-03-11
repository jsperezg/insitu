# frozen_string_literal: true

class CreateUnits < ActiveRecord::Migration[4.2]
  def change
    create_table :units do |t|
      t.string :label_short, null: false, blank: false, length: 10, index: true
      t.string :label_long, null: true, length: 50

      t.timestamps null: false
    end
  end
end
