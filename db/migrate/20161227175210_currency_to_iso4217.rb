# frozen_string_literal: true

class CurrencyToIso4217 < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :currency, :string, limit: 3, null: false, default: 'EUR'
  end
end
