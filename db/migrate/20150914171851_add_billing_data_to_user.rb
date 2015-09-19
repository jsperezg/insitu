class AddBillingDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :tax_id, :string
    add_column :users, :name, :string
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :postal_code, :string, limit: 25
    add_column :users, :state, :string
    add_column :users, :country, :string
  end
end
