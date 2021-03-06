# frozen_string_literal: true

class AddProcessTimeToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :processed_at, :datetime
  end
end
