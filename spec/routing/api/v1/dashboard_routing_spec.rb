# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DashboardController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/dashboard').to route_to('api/v1/dashboard#index')
    end
  end
end
