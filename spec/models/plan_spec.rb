# frozen_string_literal: true

require 'rails_helper'

describe Plan, type: :model do
  describe 'validation rules' do
    it 'description is mandatory' do
      plan = described_class.create
      expect(plan.errors).to be_key :description
    end

    describe 'price' do
      it 'is mandatory' do
        plan = described_class.create
        expect(plan.errors).to be_key :price
      end

      it 'is a number' do
        plan = described_class.create(price: 'asdf')
        expect(plan.errors).to be_key :price
      end

      it 'is greater than zero' do
        plan = described_class.create(price: 0)
        expect(plan.errors).to be_key :price
      end
    end

    describe 'months' do
      it 'is mandatory' do
        plan = described_class.create
        expect(plan.errors).to be_key :months
      end

      it 'is a number' do
        plan = described_class.create(months: 'asdf')
        expect(plan.errors).to be_key :months
      end

      it 'is integer' do
        plan = described_class.create(months: 1.1)
        expect(plan.errors).to be_key :months
      end

      it 'is greater than zero' do
        plan = described_class.create(months: 0)
        expect(plan.errors).to be_key :months
      end
    end

    describe 'vat_rate' do
      it 'is mandatory' do
        plan = described_class.create
        expect(plan.errors).to be_key :vat_rate
      end

      it 'is a number' do
        plan = described_class.create(vat_rate: 'asdf')
        expect(plan.errors).to be_key :vat_rate
      end

      it 'is integer' do
        plan = described_class.create(vat_rate: 1.1)
        expect(plan.errors).to be_key :vat_rate
      end

      it 'is greater than zero' do
        plan = described_class.create(vat_rate: 0)
        expect(plan.errors).to be_key :vat_rate
      end
    end

    it 'is active is default' do
      plan = described_class.create(description: 'Plan name', months: 7, price: 7.0, vat_rate: 21)
      expect(plan.is_active).to be_truthy
    end
  end
end
