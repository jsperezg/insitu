require "rails_helper"

RSpec.describe DeliveryNotesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/delivery_notes").to route_to("delivery_notes#index")
    end

    it "routes to #new" do
      expect(:get => "/delivery_notes/new").to route_to("delivery_notes#new")
    end

    it "routes to #show" do
      expect(:get => "/delivery_notes/1").to route_to("delivery_notes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/delivery_notes/1/edit").to route_to("delivery_notes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/delivery_notes").to route_to("delivery_notes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/delivery_notes/1").to route_to("delivery_notes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/delivery_notes/1").to route_to("delivery_notes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/delivery_notes/1").to route_to("delivery_notes#destroy", :id => "1")
    end

  end
end
