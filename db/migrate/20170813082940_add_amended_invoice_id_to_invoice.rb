# frozen_string_literal: true

class AddAmendedInvoiceIdToInvoice < ActiveRecord::Migration[4.2]
  def change
    add_column :invoices, :amended_invoice_id, :integer, index: true
  end
end
