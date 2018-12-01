# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'estimates/index', type: :view do
  let(:user) { create :user }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:estimates, [
             create(:estimate),
             create(:estimate)
           ])

    allow(view).to receive(:form_for_filterrific).and_return('filterrific form')
    allow(view).to receive(:will_paginate).and_return('filterrific paginator')
  end

  after do
    sign_out user
  end

  skip 'renders a list of estimates' do
    render
  end
end
