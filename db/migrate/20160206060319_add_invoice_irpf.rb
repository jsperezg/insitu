# frozen_string_literal: true

class AddInvoiceIrpf < ActiveRecord::Migration[4.2]
  def change
    add_column :invoices, :irpf, :integer
  end
end
