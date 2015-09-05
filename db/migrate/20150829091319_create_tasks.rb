class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description, null: false
      t.references :project, index: true, foreign_key: true, null: false
      t.boolean :finished, null: false, default: false

      t.timestamps null: false
    end
  end
end
