require "rails_helper"

RSpec.describe Api::V1::EstimateStatusesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/api/v1/estimate_statuses").to route_to("api/v1/estimate_statuses#index")
    end

    it "routes to #show" do
      expect(:get => "/api/v1/estimate_statuses/1").to route_to("api/v1/estimate_statuses#show", :id => "1")
    end
  end
end