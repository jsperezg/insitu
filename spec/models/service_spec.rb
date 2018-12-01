# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Service, type: :model do
  subject(:service) { build :service, attributes }

  let(:attributes) { attributes_for :service }

  it { is_expected.to be_valid }

  describe 'model validation' do
    context 'when code is missing' do
      let(:attributes) { attributes_for :service, code: '' }

      it { is_expected.not_to be_valid }
    end

    context 'when code already exists' do
      let(:another_service) { create :service }
      let(:attributes) { attributes_for :service, code: another_service.code }

      it { is_expected.not_to be_valid }
    end

    context 'when description is missing' do
      let(:attributes) { attributes_for :service, description: '' }

      it { is_expected.not_to be_valid }
    end

    context 'when price is missing' do
      let(:attributes) { attributes_for :service, price: nil }

      it { is_expected.not_to be_valid }
    end

    context 'when price is negative' do
      let(:attributes) { attributes_for :service, price: -1 }

      it { is_expected.not_to be_valid }
    end

    context 'when vat is missing' do
      let(:attributes) { attributes_for :service, vat: nil }

      it { is_expected.not_to be_valid }
    end

    context 'when unit is missing' do
      let(:attributes) { attributes_for :service, unit: nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'default values' do
    subject(:service) do
      Service.new(
        code: 'a code',
        description: 'It has a description',
        price: 1,
        unit: Unit.first,
        vat: Vat.first
      )
    end

    before do
      service.save
      service.reload
    end

    it { is_expected.to be_active }
  end
end
