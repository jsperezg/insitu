# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to be_valid }

  describe 'default values' do
    it 'User role by default' do
      user = create(:user, role_id: nil)
      user.reload

      expect(user.role_id).not_to be_nil
    end

    it 'Currency defaults to EUR' do
      user = create(:user, currency: nil)
      user.reload

      expect(user.currency).to eq('EUR')
    end
  end

  describe 'administrators' do
    it 'have perpetual license' do
      user = create(:user)
      user.reload

      expect(user.valid_until).not_to be_nil

      user.role = Role.admin
      expect(user.save).to be_truthy

      user.reload
      expect(user.valid_until).to be_nil
    end

    it "can't be banned" do
      user = create(:user, :admin)
      user.banned = true
      expect(user.save).to be_falsey

      expect(user.errors).to have_key :role_id
    end
  end

  describe 'users' do
    it 'New users are not premium' do
      user = create(:user)
      expect(user).not_to be_premium
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
      expect(user).not_to be_cif
    end

    it 'false for nif' do
      user = create(:user, country: 'ES', tax_id: '00000000X')
      expect(user).not_to be_cif
    end

    it 'false for nie' do
      user = create(:user, country: 'ES', tax_id: 'X0000000X')
      expect(user).not_to be_cif
    end

    it 'true for cif' do
      user = create(:user, country: 'ES', tax_id: 'C00000000')
      expect(user).to be_cif
    end
  end
end
