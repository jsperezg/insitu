# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminSecuredHelper, type: :helper do
  describe 'is_admin? function' do
    it 'on admin session' do
      allow(helper).to receive(:current_user).and_return(create(:user, :admin))
      expect(helper.is_admin?).to be_truthy
    end

    it 'on regular session' do
      allow(helper).to receive(:current_user).and_return(create(:user))
      expect(helper.is_admin?).to be_falsey
    end
  end
end
