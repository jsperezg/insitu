require "rails_helper"

RSpec.describe TimeLogsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/users/1/projects/1/tasks/1/time_logs").to route_to("time_logs#index", user_id: '1', project_id: '1', task_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/users/1/projects/1/tasks/1/time_logs/new").to route_to("time_logs#new", user_id: '1', project_id: '1', task_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/users/1/projects/1/tasks/1/time_logs/1").to route_to("time_logs#show", :id => "1", user_id: '1', project_id: '1', task_id: '1')
    end

    it "routes to #edit" do
      expect(:get => "/users/1/projects/1/tasks/1/time_logs/1/edit").to route_to("time_logs#edit", :id => "1", user_id: '1', project_id: '1', task_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/users/1/projects/1/tasks/1/time_logs").to route_to("time_logs#create", user_id: '1', project_id: '1', task_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/users/1/projects/1/tasks/1/time_logs/1").to route_to("time_logs#update", :id => "1", user_id: '1', project_id: '1', task_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/users/1/projects/1/tasks/1/time_logs/1").to route_to("time_logs#update", :id => "1", user_id: '1', project_id: '1', task_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/users/1/projects/1/tasks/1/time_logs/1").to route_to("time_logs#destroy", :id => "1", user_id: '1', project_id: '1', task_id: '1')
    end

  end
end
