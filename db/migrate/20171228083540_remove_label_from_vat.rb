# frozen_string_literal: true

class RemoveLabelFromVat < ActiveRecord::Migration[4.2]
  def change
    remove_column :vats, :label, :string, null: false, blank: false, index: true
  end
end
