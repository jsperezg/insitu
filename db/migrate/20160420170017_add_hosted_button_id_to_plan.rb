class AddHostedButtonIdToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :hosted_button_id, :string
  end
end
