# frozen_string_literal: true

class UserLogo < ActiveRecord::Migration
  def up
    add_attachment :users, :logo
  end

  def down
    remove_attachment :users, :logo
  end
end
