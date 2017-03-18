require 'rails_helper'

describe 'api/v1/delivery_notes/show/', type: :view  do
  let(:valid_attributes) {
    delivery_note = attributes_for :delivery_note
    delivery_note.merge(delivery_note_details_attributes: [ attributes_for(:delivery_note_detail, delivery_note_id: nil) ])
  }

  before do
    assign(:delivery_note, DeliveryNote.create(valid_attributes))
  end

  it 'Renders the requested delivery note' do
    render

    delivery_note = JSON.parse(rendered)
    expect(delivery_note.key? 'id').to be_truthy
    expect(delivery_note.key? 'number').to be_truthy
    expect(delivery_note.key? 'customer_id').to be_truthy
    expect(delivery_note.key? 'date').to be_truthy
    expect(delivery_note['delivery_note_details'].length).to eq(1)

    delivery_note['delivery_note_details'].each do |detail|
      expect(detail.key? 'id').to be_truthy
      expect(detail.key? 'service_id').to be_truthy
      expect(detail.key? 'description').to be_truthy
      expect(detail.key? 'quantity').to be_truthy
      expect(detail.key? 'price').to be_truthy
      expect(detail.key? 'invoice_detail_id').to be_truthy
    end
  end
end