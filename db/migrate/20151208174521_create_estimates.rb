class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.string :number, length: 25, null: false, blank:  false
      t.references :customer, index: true, foreign_key: true, null: false
      t.references :estimate_status, index: true, foreign_key: false, null: false
      t.date :date, null: false
      t.date :valid_until

      t.timestamps null: false
    end

    add_index :estimates, :number
  end
end
