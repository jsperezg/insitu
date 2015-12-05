require "rails_helper"

RSpec.describe VatsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/users/1/vats").to route_to("vats#index", user_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/users/1/vats/new").to route_to("vats#new", user_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/users/1/vats/1").to route_to("vats#show", :id => "1", user_id: '1')
    end

    it "routes to #edit" do
      expect(:get => "/users/1/vats/1/edit").to route_to("vats#edit", :id => "1", user_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/users/1/vats").to route_to("vats#create", user_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/users/1/vats/1").to route_to("vats#update", :id => "1", user_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/users/1/vats/1").to route_to("vats#update", :id => "1", user_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/users/1/vats/1").to route_to("vats#destroy", :id => "1", user_id: '1')
    end

  end
end
