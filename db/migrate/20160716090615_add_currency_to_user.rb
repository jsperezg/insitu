# frozen_string_literal: true

class AddCurrencyToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :currency, :string, limit: 1, default: '€', null: false
  end
end
