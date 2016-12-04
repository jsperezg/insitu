require "rails_helper"

RSpec.describe Api::V1::DeliveryNotesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/v1/delivery_notes").to route_to("api/v1/delivery_notes#index")
    end

    it "routes to #show" do
      expect(:get => "/api/v1/delivery_notes/1").to route_to("api/v1/delivery_notes#show", :id => "1")
    end

    it "routes to #invoice" do
      expect(:get => "/api/v1/delivery_notes/1/invoice").to route_to("api/v1/delivery_notes#invoice", :id => "1")
    end

    it "routes to #print" do
      expect(:get => "/api/v1/delivery_notes/1/print").to route_to("api/v1/delivery_notes#print", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/v1/delivery_notes").to route_to("api/v1/delivery_notes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/api/v1/delivery_notes/1").to route_to("api/v1/delivery_notes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api/v1/delivery_notes/1").to route_to("api/v1/delivery_notes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/v1/delivery_notes/1").to route_to("api/v1/delivery_notes#destroy", :id => "1")
    end
  end
end
