# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PlansController, type: :controller do
  render_views

  let(:valid_attributes) do
    attributes_for :plan
  end

  it 'index' do
    plan = Plan.create! valid_attributes

    get :index, format: :json

    json_response = JSON.parse(response.body)
    expect(json_response['response']).to include(JSON.parse(plan.to_json(except: %i[is_active created_at updated_at])))
  end
end
