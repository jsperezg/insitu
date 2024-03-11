# frozen_string_literal: true

class AddSendInvoicesToCustomer < ActiveRecord::Migration[4.2]
  def change
    add_column :customers, :send_invoices_to, :string
  end
end
