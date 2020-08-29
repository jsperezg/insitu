# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users/1/units').to route_to('units#index', user_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/users/1/units/new').to route_to('units#new', user_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/users/1/units/1').to route_to('units#show', id: '1', user_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/users/1/units/1/edit').to route_to('units#edit', id: '1', user_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users/1/units').to route_to('units#create', user_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/users/1/units/1').to route_to('units#update', id: '1', user_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/users/1/units/1').to route_to('units#update', id: '1', user_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1/units/1').to route_to('units#destroy', id: '1', user_id: '1')
    end
  end
end
