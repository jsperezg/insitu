require 'rails_helper'

describe 'api/v1/estimates/index', type: :view  do
  let(:valid_attributes) {
    estimate = attributes_for(:estimate)

    estimate.merge(estimate_details_attributes: [ attributes_for(:estimate_detail, estimate_id: nil) ])
  }

  before do
    @estimates = []
    @estimates << Estimate.create(valid_attributes)

    assign(:estimates, @estimates)
  end

  it 'Renders a list of estimates' do
    render

    json = JSON.parse(rendered)
    expect(json.key? 'estimates').to be_truthy
    expect(json['estimates'].length).to eq(1)

    json['estimates'].each do |estimate|
      expect(estimate.key? 'id').to be_truthy
      expect(estimate.key? 'number').to be_truthy
      expect(estimate.key? 'customer_id').to be_truthy
      expect(estimate.key? 'estimate_status_id').to be_truthy
      expect(estimate.key? 'date').to be_truthy
      expect(estimate.key? 'valid_until').to be_truthy
      expect(estimate.key? 'estimate_details').to be_truthy
      expect(estimate['estimate_details'].length).to eq(1)

      estimate['estimate_details'].each do |detail|
        expect(detail.key? 'id').to be_truthy
        expect(detail.key? 'service_id').to be_truthy
        expect(detail.key? 'description').to be_truthy
        expect(detail.key? 'quantity').to be_truthy
        expect(detail.key? 'price').to be_truthy
        expect(detail.key? 'discount').to be_truthy
        expect(detail.key? 'invoice_detail_id').to be_truthy
      end
    end
  end
end