require "rails_helper"

RSpec.describe Api::V1::PlansController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/api/v1/plans").to route_to("api/v1/plans#index")
    end
  end
end
