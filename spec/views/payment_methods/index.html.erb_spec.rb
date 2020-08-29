# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'payment_methods/index', type: :view do
  let(:user) { create :user }
  let(:payment_methods) { create_list :payment_method, 2 }

  before do
    sign_in user
    assign(:payment_methods, payment_methods)
  end

  after do
    sign_out user
  end

  xit 'renders a list of payment_methods' do
    render

    payment_methods.each do |i|
      assert_select 'tr>td', text: i[:name], count: 1
    end
  end
end
