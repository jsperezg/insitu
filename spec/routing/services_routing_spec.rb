require "rails_helper"

RSpec.describe ServicesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/users/1/services").to route_to("services#index", user_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/users/1/services/new").to route_to("services#new", user_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/users/1/services/1").to route_to("services#show", :id => "1", user_id: '1')
    end

    it "routes to #edit" do
      expect(:get => "/users/1/services/1/edit").to route_to("services#edit", :id => "1",  user_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/users/1/services").to route_to("services#create", user_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/users/1/services/1").to route_to("services#update", :id => "1", user_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/users/1/services/1").to route_to("services#update", :id => "1", user_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/users/1/services/1").to route_to("services#destroy", :id => "1",  user_id: '1')
    end

  end
end
