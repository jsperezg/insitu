require "rails_helper"

RSpec.describe Api::V1::TasksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/v1/projects/1/tasks").to route_to("api/v1/tasks#index", project_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/api/v1/projects/1/tasks/1").to route_to("api/v1/tasks#show", :id => "1", project_id: '1')
    end
    
    it "routes to #create" do
      expect(:post => "/api/v1/projects/1/tasks").to route_to("api/v1/tasks#create", project_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/api/v1/projects/1/tasks/1").to route_to("api/v1/tasks#update", :id => "1", project_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api/v1/projects/1/tasks/1").to route_to("api/v1/tasks#update", :id => "1", project_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/api/v1/projects/1/tasks/1").to route_to("api/v1/tasks#destroy", :id => "1", project_id: '1')
    end

    it "routes to #invoice_finished" do
      expect(:get => "/api/v1/projects/1/tasks/invoice_finished").to route_to("api/v1/tasks#invoice_finished", project_id: '1')
    end
  end
end
