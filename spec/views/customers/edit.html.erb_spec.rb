# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'customers/edit', type: :view do
  let(:customer) { create :customer }

  before { assign(:customer, customer) }

  after do
    sign_out user
  end

  describe('generic validations') do
    let(:user) { create :user }

    before do
      sign_in user
    end

    it 'renders the edit customer form' do
      render

      assert_select 'form[action=?][method=?]', user_customer_path(user, customer), 'post'
    end
  end

  describe 'spanish freelancer' do
    let(:user) { create(:user, country: 'ES', tax_id: '00000000L') }

    before do
      sign_in user
    end

    it 'Renders IRPF field' do
      render

      assert_select 'input[type=number][id=customer_irpf]'
    end
  end

  describe 'spanish company' do
    let(:user) { create(:user, country: 'ES', tax_id: 'C00000000') }

    before do
      sign_in user
    end

    it 'Do not renders IRPF field' do
      render

      assert_select 'input[type=number][id=customer_irpf]', false
    end
  end

  describe 'not spanish customers' do
    let(:user) { create(:user, country: 'US', tax_id: 'C00000000') }

    before do
      sign_in user
    end

    it 'Do not renders IRPF field' do
      render

      assert_select 'input[type=number][id=customer_irpf]', false
    end
  end
end
