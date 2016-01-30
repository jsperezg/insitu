class AddInvoiceDetailToEstimateDetails < ActiveRecord::Migration
  def change
    add_reference :estimate_details, :invoice_detail, index: true, foreign_key: true
  end
end
