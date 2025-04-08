# frozen_string_literal: true

require 'rails_helper'

describe 'projects/index', type: :view do
  let(:user) { create :user }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:projects, create_list(:project, 2))

    allow(view).to receive_messages(form_for_filterrific: 'filterrific form', will_paginate: 'filterrific paginator')
  end

  after do
    sign_out user
  end

  it 'renders a list of projects', skip: 'not implemented' do
    render
  end
end
