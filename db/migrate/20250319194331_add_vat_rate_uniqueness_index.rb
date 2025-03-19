# frozen_string_literal: true

class AddVatRateUniquenessIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :vats, :rate, if_exists: true
    add_index :vats, :rate, unique: true, if_not_exists: true
  end
end
