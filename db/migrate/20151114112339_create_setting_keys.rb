class CreateSettingKeys < ActiveRecord::Migration
  def change
    create_table :setting_keys do |t|
      t.string :name, null: false, index: true  
      t.integer :data_type, null: false

      t.timestamps null: false
    end
  end
end
