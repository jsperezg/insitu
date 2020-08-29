# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the InvoicesHelper. For example:
#
# describe InvoicesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe InvoicesHelper, type: :helper do
  describe 'invoice_tr' do
    it 'on invoice paid' do
      invoice = create(:invoice, invoice_status_id: create(:invoice_status, name: 'invoice_status.paid').try(:id))
      html_row = helper.invoice_tr(invoice) do
      end

      expect(html_row).to include('success')
    end

    it 'on invoice default' do
      invoice = create(:invoice, invoice_status_id: create(:invoice_status, name: 'invoice_status.default').try(:id))
      html_row = helper.invoice_tr(invoice) do
      end

      expect(html_row).to include('danger')
    end

    it 'on invoice sent' do
      invoice = create(:invoice, invoice_status_id: create(:invoice_status, name: 'invoice_status.sent').try(:id))
      html_row = helper.invoice_tr(invoice) do
      end

      expect(html_row).to include('info')
    end

    it 'on invoice active' do
      invoice = create(:invoice, invoice_status_id: create(:invoice_status, name: 'invoice_status.created').try(:id))
      html_row = helper.invoice_tr(invoice) do
      end

      expect(html_row).to include('active')
    end
  end
end
