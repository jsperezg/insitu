# frozen_string_literal: true

class AddProcessTimeToPayment < ActiveRecord::Migration[4.2]
  def change
    add_column :payments, :processed_at, :datetime
  end
end
