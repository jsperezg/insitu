# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminSecuredHelper, type: :helper do
  describe '#admin?' do
    it 'on admin session' do
      allow(helper).to receive(:current_user).and_return(create(:user, :admin))
      expect(helper).to be_admin
    end

    it 'on regular session' do
      allow(helper).to receive(:current_user).and_return(create(:user))
      expect(helper).not_to be_admin
    end
  end
end
