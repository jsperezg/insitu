# frozen_string_literal: true

class DropUserLogo < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :logo_file_name, :string
    remove_column :users, :logo_content_type, :string
    remove_column :users, :logo_file_size, :integer
    remove_column :users, :logo_updated_at, :datetime
  end
end
