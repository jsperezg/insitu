# frozen_string_literal: true

class InitializeDeviseConfirmable < ActiveRecord::Migration[4.2]
  def change
    execute('UPDATE users SET confirmed_at = NOW()')
  end
end
