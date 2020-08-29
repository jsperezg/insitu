# frozen_string_literal: true

class AddInvoiceIrpf < ActiveRecord::Migration
  def change
    add_column :invoices, :irpf, :integer
  end
end
