# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/estimates/show/', type: :view do
  let(:valid_attributes) do
    estimate = attributes_for(:estimate)
    estimate.merge(estimate_details_attributes: [attributes_for(:estimate_detail, estimate_id: nil)])
  end

  before do
    assign(:estimate, Estimate.create(valid_attributes))
  end

  it 'Renders the requested estimate' do
    render

    estimate = JSON.parse(rendered)
    expect(estimate).to be_key('id')
    expect(estimate).to be_key('number')
    expect(estimate).to be_key('customer_id')
    expect(estimate).to be_key('estimate_status_id')
    expect(estimate).to be_key('date')
    expect(estimate).to be_key('valid_until')
    expect(estimate).to be_key('estimate_details')
    expect(estimate['estimate_details'].length).to eq(1)

    expect(estimate['estimate_details']).to all(be_key('id'))
    expect(estimate['estimate_details']).to all(be_key('service_id'))
    expect(estimate['estimate_details']).to all(be_key('description'))
    expect(estimate['estimate_details']).to all(be_key('quantity'))
    expect(estimate['estimate_details']).to all(be_key('price'))
    expect(estimate['estimate_details']).to all(be_key('discount'))
    expect(estimate['estimate_details']).to all(be_key('invoice_detail_id'))
  end
end
