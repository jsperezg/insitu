class RenameDescriptionDeliveryNote < ActiveRecord::Migration
  def change
    rename_column :delivery_note_details, :custom_description, :description
  end
end
