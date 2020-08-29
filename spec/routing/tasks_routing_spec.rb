# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users/1/projects/1/tasks').to route_to('tasks#index', user_id: '1', project_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/users/1/projects/1/tasks/new').to route_to('tasks#new', user_id: '1', project_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/users/1/projects/1/tasks/1').to route_to('tasks#show', id: '1', user_id: '1', project_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/users/1/projects/1/tasks/1/edit').to route_to('tasks#edit', id: '1', user_id: '1', project_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users/1/projects/1/tasks').to route_to('tasks#create', user_id: '1', project_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/users/1/projects/1/tasks/1').to route_to('tasks#update', id: '1', user_id: '1', project_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/users/1/projects/1/tasks/1').to route_to('tasks#update', id: '1', user_id: '1', project_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1/projects/1/tasks/1').to route_to('tasks#destroy', id: '1', user_id: '1', project_id: '1')
    end

    it 'routes to #invoice_finished' do
      expect(get: '/users/1/projects/1/tasks/invoice_finished').to route_to('tasks#invoice_finished', user_id: '1', project_id: '1')
    end
  end
end
