require "rails_helper"

RSpec.describe EstimatesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/users/1/estimates").to route_to("estimates#index", user_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/users/1/estimates/new").to route_to("estimates#new", user_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/users/1/estimates/1").to route_to("estimates#show", :id => "1", user_id: '1')
    end

    it "routes to #print" do
      expect(:get => "/users/1/estimates/1/print").to route_to("estimates#print", :id => "1", user_id: '1')
    end

    it "routes to #edit" do
      expect(:get => "/users/1/estimates/1/edit").to route_to("estimates#edit", :id => "1", user_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/users/1/estimates").to route_to("estimates#create", user_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/users/1/estimates/1").to route_to("estimates#update", :id => "1", user_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/users/1/estimates/1").to route_to("estimates#update", :id => "1", user_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/users/1/estimates/1").to route_to("estimates#destroy", :id => "1", user_id: '1')
    end

  end
end
