# frozen_string_literal: true

class FixEstimateNumberIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :estimates, :number, if_exists: true
    add_index :estimates, :number, unique: true, if_not_exists: true
  end
end
