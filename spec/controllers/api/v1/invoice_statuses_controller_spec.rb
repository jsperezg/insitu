# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::InvoiceStatusesController, type: :controller do
  let(:valid_attributes) do
    { name: 'Invoice status' }
  end

  let(:user) { User.first || create(:user) }

  before do
    sign_in user
    Thread.current[:user] = user
  end

  after do
    sign_out user
  end

  describe 'GET #index' do
    it 'assigns all invoice statuses as @invoice_statuses' do
      status = InvoiceStatus.create(valid_attributes)

      get :index, format: :json
      expect(assigns(:invoice_statuses)).to include(status)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested invoice status as @invoice_status' do
      status = InvoiceStatus.create(valid_attributes)

      get :show, id: status.id, format: :json
      expect(assigns(:invoice_status)).to eq(status)
    end
  end
end
