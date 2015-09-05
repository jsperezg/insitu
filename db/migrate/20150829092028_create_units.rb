class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :label_short, null: false,  blank: false, length: 10, index: true
      t.string :label_long, null: false, blank: false, length: 50

      t.timestamps null: false
    end
  end
end
