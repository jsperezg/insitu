class AddServiceToTimeLog < ActiveRecord::Migration
  def change
    add_reference :time_logs, :service, index: true, foreign_key: true
  end
end
