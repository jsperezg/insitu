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
      user = create(:user)
      user.reload

      expect(user.valid_until).not_to be_nil

      user.role_id = @admin_role.id
      expect(user.save).to be_truthy

      user.reload
      expect(user.valid_until).to be_nil
    end

    it "can't be banned" do
      user = create(:admin_user)
      user.banned = true
      expect(user.save).to be_falsey

      expect(user.errors).to satisfy { |errors| errors.key?( :role_id )}
    end
  end

  describe 'users' do
    it 'first month is free' do
      user = create(:user)
      expect(user.valid_until).to eq(Date.today + 1.month)
    end

    it 'can be banned' do
      user = create(:user)

      user.banned = true
      expect(user.save).to be_truthy
    end
  end

  describe 'cif detection' do
    it 'false for non spanish users' do
      user = create(:user, country: 'US', tax_id: 'C00000000')
      expect(user.has_cif?).to be_falsey
    end

    it 'false for nif' do
      user = create(:user, country: 'ES', tax_id: '00000000X')
      expect(user.has_cif?).to be_falsey
    end

    it 'false for nie' do
      user = create(:user, country: 'ES', tax_id: 'X0000000X')
      expect(user.has_cif?).to be_falsey
    end

    it 'true for cif' do
      user = create(:user, country: 'ES', tax_id: 'C00000000')
      expect(user.has_cif?).to be_truthy
    end
  end
end