class RemoveIssueDate < ActiveRecord::Migration
  def up
  	remove_column :invoices, :issue_date
  end

  def down
    add_column :invoices, :issue_date, :datetime, null: false
  end
end
