# frozen_string_literal: true

class RemoveHostedButtonIdFromPlan < ActiveRecord::Migration
  def change
    remove_column :plans, :hosted_button_id
  end
end
