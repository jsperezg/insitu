# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentMethodsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users/1/payment_methods').to route_to('payment_methods#index', user_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/users/1/payment_methods/new').to route_to('payment_methods#new', user_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/users/1/payment_methods/1').to route_to('payment_methods#show', id: '1', user_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/users/1/payment_methods/1/edit').to route_to('payment_methods#edit', id: '1', user_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users/1/payment_methods').to route_to('payment_methods#create', user_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/users/1/payment_methods/1').to route_to('payment_methods#update', id: '1', user_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/users/1/payment_methods/1').to route_to('payment_methods#update', id: '1', user_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1/payment_methods/1').to route_to('payment_methods#destroy', id: '1', user_id: '1')
    end
  end
end
