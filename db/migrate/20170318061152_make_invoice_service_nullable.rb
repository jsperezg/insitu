class MakeInvoiceServiceNullable < ActiveRecord::Migration
  def change
    change_column :invoice_details, :service_id, :integer, null: true
  end
end
