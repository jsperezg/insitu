# frozen_string_literal: true

class RenameDescriptionDeliveryNote < ActiveRecord::Migration[4.2]
  def change
    rename_column :delivery_note_details, :custom_description, :description
  end
end
