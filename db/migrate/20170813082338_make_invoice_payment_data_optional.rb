# frozen_string_literal: true

class MakeInvoicePaymentDataOptional < ActiveRecord::Migration
  def change
    change_column :invoices, :payment_method_id, :integer, null: true
    change_column :invoices, :payment_date, :date, null: true
  end
end
