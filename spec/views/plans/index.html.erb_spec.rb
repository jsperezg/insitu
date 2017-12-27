# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'plans/index', type: :view do
  let(:user) { create(:user, :admin) }
  before(:each) do
    sign_in user
    assign(:plans, create_list(:plan, 2))

    allow(view).to receive(:form_for_filterrific).and_return('filterrific form')
    allow(view).to receive(:will_paginate).and_return('filterrific paginator')
  end

  after(:each) do
    sign_out user
  end

  it 'renders a list of plans' do
    render
  end
end
