class AddActiveToService < ActiveRecord::Migration
  def change
    add_column :services, :active, :boolean, required: true, default: true, index: true
  end
end
