require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AdminSecuredHelper. For example:
#
# describe AdminSecuredHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AdminSecuredHelper, type: :helper do
  describe "is_admin? function" do
    it 'on admin session' do
      allow(helper).to receive(:current_user).and_return(create(:admin_user))
      expect(helper.is_admin?).to be_truthy
    end

    it 'on regular session' do
      allow(helper).to receive(:current_user).and_return(create(:user))
      expect(helper.is_admin?).to be_falsey
    end
  end
end
