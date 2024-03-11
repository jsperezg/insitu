# frozen_string_literal: true

class AddDefaultToVat < ActiveRecord::Migration[4.2]
  def change
    add_column :vats, :default, :boolean, required: true, default: false, index: true
  end
end
