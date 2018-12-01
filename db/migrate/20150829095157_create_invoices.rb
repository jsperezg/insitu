# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :number, length: 25, null: false, blank: false
      t.date :date, null: false
      t.references :payment_method, index: true, foreign_key: true, null: false
      t.references :customer, index: true, foreign_key: true, null: false
      t.references :invoice_status, index: true, foreign_key: false, null: false
      t.date :payment_date, null: false
      t.date :paid_on

      t.timestamps null: false
    end
    add_index :invoices, :number
  end
end
