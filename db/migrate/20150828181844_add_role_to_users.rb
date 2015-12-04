class AddRoleToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :role_id, :integer
  	add_foreign_key :users, :roles
  end
end
