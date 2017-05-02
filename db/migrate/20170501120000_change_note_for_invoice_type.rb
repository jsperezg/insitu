class ChangeNoteForInvoiceType < ActiveRecord::Migration[5.0]
  def up
    change_column :payment_methods, :note_for_invoice, :text
  end

  def down
    change_column :payment_methods, :note_for_invoice, :string
  end
end
