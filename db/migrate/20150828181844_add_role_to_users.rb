# frozen_string_literal: true

class AddRoleToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :role_id, :integer
    add_foreign_key :users, :roles
  end
end
