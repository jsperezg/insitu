# frozen_string_literal: true

class AddHostedButtonIdToPlan < ActiveRecord::Migration[4.2]
  def change
    add_column :plans, :hosted_button_id, :string
  end
end
