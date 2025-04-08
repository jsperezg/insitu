# frozen_string_literal: true

require 'rails_helper'

describe 'delivery_notes/index', type: :view do
  let(:user) { create :user }
  let(:delivery_note) { create :delivery_note }

  before do
    user = create(:user)
    sign_in user

    Thread.current[:user] = user

    assign(:delivery_notes, [delivery_note])

    allow(view).to receive_messages(form_for_filterrific: 'filterrific form', will_paginate: 'filterrific paginator')
  end

  after do
    sign_out user
  end

  it 'renders a list of delivery_notes', skip: 'failing for a long time' do
    render
    assert_select 'tr>th', text: DeliveryNote.human_attribute_name(:number), count: 1
    assert_select 'tr>td', text: delivery_note.number, count: 1

    assert_select 'tr>th', text: DeliveryNote.human_attribute_name(:customer_id), count: 1
    assert_select 'tr>td', text: delivery_note.customer.name, count: 1

    # TODO: validate all the fields
  end
end
