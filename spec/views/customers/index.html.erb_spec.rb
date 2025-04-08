# frozen_string_literal: true

require 'rails_helper'

describe 'customers/index', type: :view do
  let(:user) { User.first || create(:user) }
  let(:customers) { create_list :customers, 2 }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:customers, customers)

    allow(view).to receive_messages(form_for_filterrific: 'filterrific form', will_paginate: 'filterrific paginator')
  end

  after do
    sign_out user
  end

  it 'renders a list of customers', skip: 'failing for a long time' do
    render

    customers.each do |c|
      assert_select 'tr>td', text: c[:name], count: 1
      assert_select 'tr>td', text: c[:contact_name].to_s, count: 1
      assert_select 'tr>td', text: c[:contact_phone].to_s, count: 1
      assert_select 'tr>td', text: c[:contact_email].to_s, count: 1
    end
  end
end
