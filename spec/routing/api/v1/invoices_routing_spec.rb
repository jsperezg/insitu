require "rails_helper"

RSpec.describe InvoicesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/v1/invoices").to route_to("api/v1/invoices#index")
    end

    it "routes to #show" do
      expect(:get => "/api/v1/invoices/1").to route_to("api/v1/invoices#show", :id => "1")
    end

    it "routes to #print" do
      expect(:get => "/api/v1/invoices/1/print").to route_to("api/v1/invoices#print", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/v1/invoices").to route_to("api/v1/invoices#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/api/v1/invoices/1").to route_to("api/v1/invoices#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api/v1/invoices/1").to route_to("api/v1/invoices#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/v1/invoices/1").to route_to("api/v1/invoices#destroy", :id => "1")
    end

  end
end
