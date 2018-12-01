# frozen_string_literal: true

class MakeEstimateServiceNullable < ActiveRecord::Migration
  def change
    change_column :estimate_details, :service_id, :integer, null: true
  end
end
