# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IpnListenerController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/ipn_listener').to route_to('ipn_listener#create')
    end
  end
end
