# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'IpnListener', type: :request do
  describe 'POST /ipn_listener' do
    it 'Responds OK' do
      post ipn_listener_index_path
      expect(response).to have_http_status(:ok)
    end
  end
end
