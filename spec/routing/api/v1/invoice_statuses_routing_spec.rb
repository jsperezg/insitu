require "rails_helper"

RSpec.describe Api::V1::InvoiceStatusesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/v1/invoice_statuses").to route_to("api/v1/invoice_statuses#index")
    end

    it "routes to #show" do
      expect(:get => "/api/v1/invoice_statuses/1").to route_to("api/v1/invoice_statuses#show", :id => "1")
    end
  end
end