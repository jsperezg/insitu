# frozen_string_literal: true

require 'rails_helper'

describe 'api/v1/dashboard/index', type: :view do
  before do
    current_user = User.first || create(:user)
    reports = TotalsCalculator.for(current_user)
    assign(:reports, reports)

    allow(view).to receive(:current_user).and_return(current_user)
  end

  it 'Renders a list of customers' do
    render

    json = JSON.parse(rendered)
    expect(json).to have_key 'past_year'
    expect(json).to have_key 'current_year'
    expect(json).to have_key 'current_month'
    expect(json).to have_key 'last_year'

    expect(json['past_year']).to have_key 'net'
    expect(json['past_year']).to have_key 'discounts'
  end
end
