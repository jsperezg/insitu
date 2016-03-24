class AddValidUntilToUser < ActiveRecord::Migration
  def change
    add_column :users, :valid_until, :date
  end
end
