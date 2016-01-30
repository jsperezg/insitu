class AddTaskInvoiceDetail < ActiveRecord::Migration
  def change
    add_reference :time_logs, :invoice_detail, index: true
  end
end
