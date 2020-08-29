# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeliveryNotesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users/1/delivery_notes').to route_to('delivery_notes#index', user_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/users/1/delivery_notes/new').to route_to('delivery_notes#new', user_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/users/1/delivery_notes/1').to route_to('delivery_notes#show', id: '1', user_id: '1')
    end

    it 'routes to #forward_email' do
      expect(get: '/users/1/delivery_notes/1/forward_email').to route_to('delivery_notes#forward_email', id: '1', user_id: '1')
    end

    it 'routes to #invoice' do
      expect(get: '/users/1/delivery_notes/1/invoice').to route_to('delivery_notes#invoice', id: '1', user_id: '1')
    end

    it 'routes to #print' do
      expect(get: '/users/1/delivery_notes/1/print').to route_to('delivery_notes#print', id: '1', user_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/users/1/delivery_notes/1/edit').to route_to('delivery_notes#edit', id: '1', user_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users/1/delivery_notes').to route_to('delivery_notes#create', user_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/users/1/delivery_notes/1').to route_to('delivery_notes#update', id: '1', user_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/users/1/delivery_notes/1').to route_to('delivery_notes#update', id: '1', user_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1/delivery_notes/1').to route_to('delivery_notes#destroy', id: '1', user_id: '1')
    end
  end
end
