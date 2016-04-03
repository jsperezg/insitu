require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the EstimatesHelper. For example:
#
# describe EstimatesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe EstimatesHelper, type: :helper do
  describe "estimate_tr" do
    it "accepted estimate" do
      estimate = create(:estimate, estimate_status_id: create(:estimate_status, name: 'estimate_status.accepted').try(:id))

      html_row = helper.estimate_tr(estimate) do
      end

      expect(html_row).to include('success')
    end

    it "created estimate" do
      estimate = create(:estimate, estimate_status_id: create(:estimate_status, name: 'estimate-status.created').try(:id))

      html_row = helper.estimate_tr(estimate) do
      end

      expect(html_row).to include('active')
    end

    it "sent estimate" do
      estimate = create(:estimate, estimate_status_id: create(:estimate_status, name: 'estimate_status.sent').try(:id))

      html_row = helper.estimate_tr(estimate) do
      end

      expect(html_row).to include('info')
    end

    it 'rejected estimate' do
      estimate = create(:estimate, estimate_status_id: create(:estimate_status, name: 'estimate_status.rejected').try(:id))

      html_row = helper.estimate_tr(estimate) do
      end

      expect(html_row).to include('danger')
    end
  end
end
