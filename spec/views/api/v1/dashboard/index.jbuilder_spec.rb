require 'rails_helper'

describe 'api/v1/dashboard/index', type: :view  do
  before do
    current_user = User.first || create(:user)
    reports =  InvoiceDetail.calculate_totals_for(current_user)
    assign(:reports, reports)

    allow(view).to receive(:current_user).and_return(current_user)
  end

  it 'Renders a list of customers' do
    render

    json = JSON.parse(rendered)
    expect(json.key? "past_year").to be_truthy
    expect(json.key? "current_year").to be_truthy
    expect(json.key? "current_month").to be_truthy
    expect(json.key? "last_year").to be_truthy

    expect(json['past_year'].key? 'net').to be_truthy
    expect(json['past_year'].key? 'discounts').to be_truthy
  end
end