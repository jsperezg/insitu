# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/delivery_notes/show/', type: :view do
  let(:valid_attributes) do
    delivery_note = attributes_for :delivery_note
    delivery_note.merge(delivery_note_details_attributes: [attributes_for(:delivery_note_detail, delivery_note_id: nil)])
  end

  before do
    assign(:delivery_note, DeliveryNote.create(valid_attributes))
  end

  it 'Renders the requested delivery note' do
    render

    delivery_note = JSON.parse(rendered)
    expect(delivery_note).to be_key('id')
    expect(delivery_note).to be_key('number')
    expect(delivery_note).to be_key('customer_id')
    expect(delivery_note).to be_key('date')
    expect(delivery_note['delivery_note_details'].length).to eq(1)

    expect(delivery_note['delivery_note_details']).to all(be_key('id'))
    expect(delivery_note['delivery_note_details']).to all(be_key('service_id'))
    expect(delivery_note['delivery_note_details']).to all(be_key('description'))
    expect(delivery_note['delivery_note_details']).to all(be_key('quantity'))
    expect(delivery_note['delivery_note_details']).to all(be_key('price'))
    expect(delivery_note['delivery_note_details']).to all(be_key('invoice_detail_id'))
  end
end
