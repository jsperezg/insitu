# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/payment_methods/index', type: :view do
  let(:payment_methods) { create_list :payment_method, 2 }

  before do
    assign(:payment_methods, payment_methods)
  end

  it 'Renders a list of payment methods' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('payment_methods')
    expect(json['payment_methods'].length).to be(2)

    expect(json['payment_methods']).to all(be_key('id'))
    expect(json['payment_methods']).to all(be_key('name'))
    expect(json['payment_methods']).to all(be_key('note_for_invoice'))
    expect(json['payment_methods']).to all(be_key('default'))
  end
end
