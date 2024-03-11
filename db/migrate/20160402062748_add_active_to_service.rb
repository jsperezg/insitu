# frozen_string_literal: true

class AddActiveToService < ActiveRecord::Migration[4.2]
  def change
    add_column :services, :active, :boolean, required: true, default: true, index: true
  end
end
