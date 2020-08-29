# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/delivery_notes/index', type: :view do
  let(:valid_attributes) do
    delivery_note = attributes_for :delivery_note
    delivery_note.merge(delivery_note_details_attributes: [attributes_for(:delivery_note_detail, delivery_note_id: nil)])
  end

  before do
    delivery_notes = []
    delivery_notes << DeliveryNote.create(valid_attributes)

    assign(:delivery_notes, delivery_notes)
  end

  it 'Renders a list of delivery notes' do
    render

    json = JSON.parse(rendered)
    expect(json).to be_key('delivery_notes')
    expect(json['delivery_notes'].length).to eq(1)

    json['delivery_notes'].each do |delivery_note|
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
end
