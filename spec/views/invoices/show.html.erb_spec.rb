# frozen_string_literal: true

require 'rails_helper'

describe 'invoices/show', type: :view do
  let(:user) { create :user }

  before do
    sign_in user

    Thread.current[:user] = user
    create(:payment_method, :default)

    @invoice = assign(:invoice, create(:invoice))
  end

  after do
    sign_out user
  end

  it 'renders attributes in <p>', skip: 'not implemented' do
    render
  end
end
