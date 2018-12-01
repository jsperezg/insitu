# frozen_string_literal: true

class CreateDeliveryNoteDetails < ActiveRecord::Migration
  def change
    create_table :delivery_note_details do |t|
      t.references :delivery_note, index: true, foreign_key: true, null: false
      t.references :service, index: true, foreign_key: true, null: false
      t.decimal :quantity, precision: 7, scale: 2, null: false
      t.decimal :price, precision: 7, scale: 2, null: false
      t.string :custom_description

      t.timestamps null: false
    end
  end
end
