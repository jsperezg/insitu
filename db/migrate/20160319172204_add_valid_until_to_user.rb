# frozen_string_literal: true

class AddValidUntilToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :valid_until, :date
  end
end
