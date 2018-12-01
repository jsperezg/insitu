# frozen_string_literal: true

class CreateTimeLogs < ActiveRecord::Migration
  def change
    create_table :time_logs do |t|
      t.string :description, null: false, blank: false
      t.date :date, null: false
      t.integer :time_spent, null: false
      t.references :task, index: true, foreign_key: true, null: false
      t.references :service, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
