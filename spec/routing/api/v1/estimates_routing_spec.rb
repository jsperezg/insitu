# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EstimatesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/estimates').to route_to('api/v1/estimates#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/estimates/1').to route_to('api/v1/estimates#show', id: '1')
    end

    it 'routes to #print' do
      expect(get: '/api/v1/estimates/1/print').to route_to('api/v1/estimates#print', id: '1')
    end

    it 'routes to #invoice' do
      expect(get: '/api/v1/estimates/1/invoice').to route_to('api/v1/estimates#invoice', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/estimates').to route_to('api/v1/estimates#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/estimates/1').to route_to('api/v1/estimates#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/estimates/1').to route_to('api/v1/estimates#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/estimates/1').to route_to('api/v1/estimates#destroy', id: '1')
    end
  end
end
