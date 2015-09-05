class CreateDeliveryNotes < ActiveRecord::Migration
  def change
    create_table :delivery_notes do |t|
      t.string :number, length: 25, null: false, blank: false
      t.references :customer, index: true, foreign_key: true, null: false
      t.datetime :date, null: false

      t.timestamps null: false
    end
  end
end
