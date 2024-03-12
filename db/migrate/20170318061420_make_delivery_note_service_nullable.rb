# frozen_string_literal: true

class MakeDeliveryNoteServiceNullable < ActiveRecord::Migration[4.2]
  def change
    change_column :delivery_note_details, :service_id, :integer, null: true
  end
end
