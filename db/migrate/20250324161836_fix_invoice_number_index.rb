# frozen_string_literal: true

class FixInvoiceNumberIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :invoices, :number, if_exists: true
    add_index :invoices, :number, unique: true, if_not_exists: true
  end
end
