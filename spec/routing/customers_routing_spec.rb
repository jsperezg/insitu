require "rails_helper"

RSpec.describe CustomersController, type: :routing do
  describe "routing" do

    it "routes to #index" do      
      expect(:get => "/users/1/customers").to route_to("customers#index", user_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/users/1/customers/new").to route_to("customers#new", user_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/users/1/customers/1").to route_to("customers#show", user_id: '1', :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/users/1/customers/1/edit").to route_to("customers#edit", user_id: '1', :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/users/1/customers").to route_to("customers#create", user_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/users/1/customers/1").to route_to("customers#update", user_id: '1', :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/users/1/customers/1").to route_to("customers#update", user_id: '1', :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/users/1/customers/1").to route_to("customers#destroy", user_id: '1', :id => "1")
    end

  end
end
