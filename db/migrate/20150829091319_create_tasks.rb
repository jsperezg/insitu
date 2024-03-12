# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[4.2]
  def change
    create_table :tasks do |t|
      t.string :name, null: :false
      t.string :description, limit: 4096
      t.references :project, index: true, foreign_key: true, null: false
      t.date :finish_date
      t.date :dead_line
      t.integer :priority, null: false, default: 1

      t.timestamps null: false
    end
  end
end
