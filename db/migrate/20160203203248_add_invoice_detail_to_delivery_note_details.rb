# frozen_string_literal: true

class AddInvoiceDetailToDeliveryNoteDetails < ActiveRecord::Migration
  def change
    add_reference :delivery_note_details, :invoice_detail, index: true, foreign_key: true
  end
end
