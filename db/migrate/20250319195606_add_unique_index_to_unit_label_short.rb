class AddUniqueIndexToUnitLabelShort < ActiveRecord::Migration[7.0]
  def change
    remove_index :units, name: :label_short, if_exists: true
    add_index :units, :label_short, unique: true, if_not_exists: true
  end
end
