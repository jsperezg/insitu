class AddCurrencyToUser < ActiveRecord::Migration
  def change
    add_column :users, :currency, :string, limit: 1, default: '€', null: false
  end
end
