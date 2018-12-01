# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'customers/new', type: :view do
  before { assign(:customer, Customer.new) }

  after do
    sign_out user
  end

  describe 'generic validations' do
    let(:user) { create :user }

    before do
      sign_in user
    end

    it 'Renders a form tag' do
      render

      assert_select 'form[action=?][method=?]', user_customers_path(user.id), 'post'
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
