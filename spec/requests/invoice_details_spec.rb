require 'rails_helper'

RSpec.describe "InvoiceDetails", type: :request do
  describe "GET /invoice_details" do
    it "works! (now write some real specs)" do
      get invoice_details_path
      expect(response).to have_http_status(200)
    end
  end
end
