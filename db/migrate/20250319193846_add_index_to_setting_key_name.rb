class AddIndexToSettingKeyName < ActiveRecord::Migration[7.0]
  def change
    remove_index :setting_keys, column: :name, if_exists: true
    add_index :setting_keys, :name, unique: true, if_not_exists: true
  end
end
