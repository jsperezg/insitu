# frozen_string_literal: true

class RemoveLabelFromVat < ActiveRecord::Migration
  def change
    remove_column :vats, :label, :string, null: false, blank: false, index: true
  end
end
