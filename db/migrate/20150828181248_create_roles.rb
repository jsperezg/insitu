# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :roles do |t|
      t.string :description

      t.timestamps null: false
    end
    add_index :roles, :description
  end
end
