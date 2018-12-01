# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/payment_methods/show/', type: :view do
  before do
    assign(:payment_method, create(:payment_method))
  end

  it 'Renders the requested payment method' do
    render

    payment_method = JSON.parse(rendered)
    expect(payment_method).to be_key('id')
    expect(payment_method).to be_key('name')
    expect(payment_method).to be_key('note_for_invoice')
    expect(payment_method).to be_key('default')
  end
end
