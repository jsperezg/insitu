# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/estimates/index', type: :view do
  let(:valid_attributes) do
    estimate = attributes_for(:estimate)

    estimate.merge(estimate_details_attributes: [attributes_for(:estimate_detail, estimate_id: nil)])
  end

  let(:estimates) { [Estimate.create(valid_attributes)] }

  before do
    assign(:estimates, estimates)
  end

  it 'Renders a list of estimates' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('estimates')
    expect(json['estimates'].length).to eq(1)

    json['estimates'].each do |estimate|
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
end
