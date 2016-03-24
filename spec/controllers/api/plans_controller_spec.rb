require 'rails_helper'

RSpec.describe Api::PlansController, type: :controller do
  let(:valid_attributes) {
    attributes_for :plan
  }

  it 'index' do
    plan = Plan.create! valid_attributes
    get :index

    json_response = JSON.parse(response.body)
    expect(json_response).to include(JSON.parse(plan.to_json(except: [:is_active, :created_at, :updated_at])))
  end
end
