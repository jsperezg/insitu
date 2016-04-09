require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user_role = create(:role)
    @admin_role = create(:admin_role)
  end

  describe 'default values' do
    it 'User role by default' do


      user = create(:user, role_id: nil)
      user.reload

      expect(user.role_id).to eq(@user_role.id)
    end
  end

  describe 'administrators' do
    it 'have perpetual license' do
      user = create(:user, valid_until: Date.today + 365.days)
      expect(user.valid_until).not_to be_nil

      user.role_id = @admin_role.id
      expect(user.save).to be_truthy

      user.reload
      expect(user.valid_until).to be_nil
    end
  end

  describe 'users' do
    it 'first month is free' do
      user = create(:user)
      expect(user.valid_until).to eq(Date.today + 1.month)
    end
  end
end