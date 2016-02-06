class AddInvoiceIrpf < ActiveRecord::Migration
  def change
    add_column :invoices, :irpf, :integer
  end
end
