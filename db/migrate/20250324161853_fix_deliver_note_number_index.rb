# frozen_string_literal: true

class FixDeliverNoteNumberIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :delivery_notes, :number, if_exists: true
    add_index :delivery_notes, :number, unique: true, if_not_exists: true
  end
end
