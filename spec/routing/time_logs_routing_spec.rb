require "rails_helper"

RSpec.describe TimeLogsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/time_logs").to route_to("time_logs#index")
    end

    it "routes to #new" do
      expect(:get => "/time_logs/new").to route_to("time_logs#new")
    end

    it "routes to #show" do
      expect(:get => "/time_logs/1").to route_to("time_logs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/time_logs/1/edit").to route_to("time_logs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/time_logs").to route_to("time_logs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/time_logs/1").to route_to("time_logs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/time_logs/1").to route_to("time_logs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/time_logs/1").to route_to("time_logs#destroy", :id => "1")
    end

  end
end
