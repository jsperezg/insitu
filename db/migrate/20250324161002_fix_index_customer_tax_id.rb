# frozen_string_literal: true

class FixIndexCustomerTaxId < ActiveRecord::Migration[7.0]
  def change
    remove_index :customers, :tax_id, if_exists: true
    add_index :customers, :tax_id, unique: true, if_not_exists: true
  end
end
