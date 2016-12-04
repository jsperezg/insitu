require 'rails_helper'

describe 'api/v1/payment_methods/show/', type: :view  do
  before do
    assign(:payment_method, create(:payment_method))
  end

  it 'Renders the requested payment method' do
    render

    payment_method = JSON.parse(rendered)
    expect(payment_method.key? 'id').to be_truthy
    expect(payment_method.key? 'name').to be_truthy
    expect(payment_method.key? 'note_for_invoice').to be_truthy
    expect(payment_method.key? 'default').to be_truthy
  end
end