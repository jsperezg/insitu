# frozen_string_literal: true

class AddTaskInvoiceDetail < ActiveRecord::Migration[4.2]
  def change
    add_reference :time_logs, :invoice_detail, index: true
  end
end
