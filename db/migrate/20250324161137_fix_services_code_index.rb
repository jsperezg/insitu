# frozen_string_literal: true

class FixServicesCodeIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :services, :code, if_exists: true
    add_index :services, :code, unique: true, if_not_exists: true
  end
end
