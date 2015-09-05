require "rails_helper"

RSpec.describe InvoiceDetailsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/invoice_details").to route_to("invoice_details#index")
    end

    it "routes to #new" do
      expect(:get => "/invoice_details/new").to route_to("invoice_details#new")
    end

    it "routes to #show" do
      expect(:get => "/invoice_details/1").to route_to("invoice_details#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/invoice_details/1/edit").to route_to("invoice_details#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/invoice_details").to route_to("invoice_details#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/invoice_details/1").to route_to("invoice_details#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/invoice_details/1").to route_to("invoice_details#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/invoice_details/1").to route_to("invoice_details#destroy", :id => "1")
    end

  end
end
