require 'rails_helper'

describe 'api/v1/payment_methods/index', type: :view  do
  before do
    @payment_methods = []

    2.times do |i|
      @payment_methods << create(:payment_method)
    end

    assign(:payment_methods, @payment_methods)
  end

  it 'Renders a list of payment methods' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "payment_methods").to be_truthy
    expect(json['payment_methods'].length).to be(2)

    json['payment_methods'].each do |payment_method|
      expect(payment_method.key? 'id').to be_truthy
      expect(payment_method.key? 'name').to be_truthy
      expect(payment_method.key? 'note_for_invoice').to be_truthy
      expect(payment_method.key? 'default').to be_truthy
    end
  end
end