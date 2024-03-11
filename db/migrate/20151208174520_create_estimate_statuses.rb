# frozen_string_literal: true

class CreateEstimateStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :estimate_statuses do |t|
      t.string :name, blank: false, null: false

      t.timestamps null: false
    end
  end
end
