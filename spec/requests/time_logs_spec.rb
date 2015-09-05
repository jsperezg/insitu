require 'rails_helper'

RSpec.describe "TimeLogs", type: :request do
  describe "GET /time_logs" do
    it "works! (now write some real specs)" do
      get time_logs_path
      expect(response).to have_http_status(200)
    end
  end
end
