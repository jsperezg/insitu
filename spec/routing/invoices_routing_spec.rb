# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoicesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users/1/invoices').to route_to('invoices#index', user_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/users/1/invoices/new').to route_to('invoices#new', user_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/users/1/invoices/1').to route_to('invoices#show', id: '1', user_id: '1')
    end

    it 'routes to #print' do
      expect(get: '/users/1/invoices/1/print').to route_to('invoices#print', id: '1', user_id: '1')
    end

    it 'routes to #forward_email' do
      expect(get: '/users/1/invoices/1/forward_email').to route_to('invoices#forward_email', id: '1', user_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/users/1/invoices/1/edit').to route_to('invoices#edit', id: '1', user_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users/1/invoices').to route_to('invoices#create', user_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/users/1/invoices/1').to route_to('invoices#update', id: '1', user_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/users/1/invoices/1').to route_to('invoices#update', id: '1', user_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1/invoices/1').to route_to('invoices#destroy', id: '1', user_id: '1')
    end

    it 'routes to #cancel' do
      expect(delete: '/users/1/invoices/1/cancel').to route_to('invoices#cancel', id: '1', user_id: '1')
    end
  end
end
