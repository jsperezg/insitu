# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users/1/projects').to route_to('projects#index', user_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/users/1/projects/new').to route_to('projects#new', user_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/users/1/projects/1').to route_to('projects#show', id: '1', user_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/users/1/projects/1/edit').to route_to('projects#edit', id: '1', user_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users/1/projects').to route_to('projects#create', user_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/users/1/projects/1').to route_to('projects#update', id: '1', user_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/users/1/projects/1').to route_to('projects#update', id: '1', user_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1/projects/1').to route_to('projects#destroy', id: '1', user_id: '1')
    end
  end
end
