# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false, blank: false
      t.references :project_status, index: true, foreign_key: false, null: false
      t.references :customer, index: true, foreign_key: false, null: false

      t.timestamps null: false
    end
  end
end
