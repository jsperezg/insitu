class CreateTimeLogs < ActiveRecord::Migration
  def change
    create_table :time_logs do |t|
      t.string :description, null: false, blank: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.references :project, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end