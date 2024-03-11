# frozen_string_literal: true

class MakeInvoiceServiceNullable < ActiveRecord::Migration[4.2]
  def change
    change_column :invoice_details, :service_id, :integer, null: true
  end
end
