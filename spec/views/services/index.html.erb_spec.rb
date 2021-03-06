# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'services/index', type: :view do
  let(:user) { create :user }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:services, [
             create(:service),
             create(:service)
           ])

    allow(view).to receive(:form_for_filterrific).and_return('filterrific form')
    allow(view).to receive(:will_paginate).and_return('filterrific paginator')
  end

  after do
    sign_out user
  end

  skip 'renders a list of services' do
    render
    assert_select 'tr>th', text: Service.human_attribute_name(:code), count: 1
  end
end
