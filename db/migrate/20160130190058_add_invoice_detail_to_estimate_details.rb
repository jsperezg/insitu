# frozen_string_literal: true

class AddInvoiceDetailToEstimateDetails < ActiveRecord::Migration[4.2]
  def change
    add_reference :estimate_details, :invoice_detail, index: true, foreign_key: true
  end
end
