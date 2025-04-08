# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'plans/index', type: :view do
  let(:user) { create(:user, :admin) }

  before do
    sign_in user
    assign(:plans, create_list(:plan, 2))

    allow(view).to receive_messages(form_for_filterrific: 'filterrific form', will_paginate: 'filterrific paginator')
  end

  after do
    sign_out user
  end

  it 'renders a list of plans', skip: 'not implemented' do
    render
  end
end
