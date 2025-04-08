# frozen_string_literal: true

class FixPaymentMethodNameIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :payment_methods, :name, if_exists: true
    add_index :payment_methods, :name, unique: true, if_not_exists: true
  end
end
