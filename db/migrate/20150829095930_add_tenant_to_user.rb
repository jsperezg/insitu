class AddTenantToUser < ActiveRecord::Migration
  def change
    add_column :users, :tenant, :string

    User.all.each do |user|
      user[:tenant]  = "user_#{ user.id }"
      user.save
    end
  end
end
