class AddSendInvoicesToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :send_invoices_to, :string
  end
end
