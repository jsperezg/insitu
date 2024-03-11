# frozen_string_literal: true

class CreateInvoiceStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :invoice_statuses do |t|
      t.string :name, blank: false, null: false

      t.timestamps null: false
    end
  end
end
