# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/invoice_statuses/index', type: :view do
  let(:invoice_statuses) { create_list :invoice_status, 2 }

  before do
    assign(:invoice_statuses, invoice_statuses)
  end

  it 'Renders a list of invoice statuses' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('invoice_statuses')
    expect(json['invoice_statuses'].length).to be(2)

    json['invoice_statuses'].each do |status|
      expect(status).to be_key('id')
      expect(status).to be_key('name')

      expect(status['name']).not_to be_empty
      expect(status['id']).not_to be_nil
    end
  end
end
