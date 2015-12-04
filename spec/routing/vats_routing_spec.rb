require "rails_helper"

RSpec.describe VatsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/vats").to route_to("vats#index")
    end

    it "routes to #new" do
      expect(:get => "/vats/new").to route_to("vats#new")
    end

    it "routes to #show" do
      expect(:get => "/vats/1").to route_to("vats#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/vats/1/edit").to route_to("vats#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/vats").to route_to("vats#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/vats/1").to route_to("vats#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/vats/1").to route_to("vats#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/vats/1").to route_to("vats#destroy", :id => "1")
    end

  end
end
