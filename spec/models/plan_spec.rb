require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'validation rules' do
    it 'description is mandatory' do
      plan = Plan.new
      expect(plan.save).to be_falsey
      expect(plan.errors).to satisfy { |errors| errors.key? :description }
    end

    describe 'price' do
      it 'is mandatory' do
        plan = Plan.new
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :price }
      end

      it 'is a number' do
        plan = Plan.new(price: 'asdf')
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :price }
      end

      it 'is greater than zero' do
        plan = Plan.new(price: 0)
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :price }
      end
    end

    describe 'months' do
      it 'is mandatory' do
        plan = Plan.new
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :months }
      end

      it 'is a number' do
        plan = Plan.new(months: 'asdf')
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :months }
      end

      it 'is integer' do
        plan = Plan.new(months: 1.1)
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :months }
      end

      it 'is greater than zero' do
        plan = Plan.new(months: 0)
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :months }
      end
    end

    describe 'vat_rate' do
      it 'is mandatory' do
        plan = Plan.new
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :vat_rate }
      end

      it 'is a number' do
        plan = Plan.new(vat_rate: 'asdf')
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :vat_rate }
      end

      it 'is integer' do
        plan = Plan.new(vat_rate: 1.1)
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :vat_rate }
      end

      it 'is greater than zero' do
        plan = Plan.new(vat_rate: 0)
        expect(plan.save).to be_falsey
        expect(plan.errors).to satisfy { |errors| errors.key? :vat_rate }
      end
    end

    it 'is active is default' do
      plan = Plan.new(description: 'Plan name', months: 7, price: 7.0, vat_rate: 21)
      expect(plan.save).to be_truthy
      expect(plan.is_active).to be_truthy
    end
  end
end
