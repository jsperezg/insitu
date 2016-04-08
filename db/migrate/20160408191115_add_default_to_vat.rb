class AddDefaultToVat < ActiveRecord::Migration
  def change
    add_column :vats, :default, :boolean, required: true, default: false, index: true
  end
end
