# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'invoices/index', type: :view do
  let(:user) { create :user }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:invoices, [
             create(:invoice),
             create(:invoice)
           ])

    allow(view).to receive(:form_for_filterrific).and_return('filterrific form')
    allow(view).to receive(:will_paginate).and_return('filterrific paginator')
  end

  after do
    sign_out user
  end

  skip 'renders a list of invoices' do
    render
  end
end
