require "rails_helper"

RSpec.describe DashboardController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/users/1/dashboard").to route_to("dashboard#index", user_id: '1')
    end
  end
end
