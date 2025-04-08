# frozen_string_literal: true

require 'rails_helper'

describe 'services/index', type: :view do
  let(:user) { create :user }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:services, create_list(:service, 2))
    allow(view).to receive_messages(form_for_filterrific: 'filterrific form', will_paginate: 'filterrific paginator')
  end

  after do
    sign_out user
  end

  it 'renders a list of services', skip: 'no filterrific support' do
    render
    assert_select 'tr>th', text: Service.human_attribute_name(:code), count: 1
  end
end
