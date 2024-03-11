# frozen_string_literal: true

class CreatePaymentMethods < ActiveRecord::Migration[4.2]
  def change
    create_table :payment_methods do |t|
      t.string :name, null: false, blank: false
      t.string :note_for_invoice
      t.boolean :default, null: false, default: false

      t.timestamps null: false
    end
  end
end
