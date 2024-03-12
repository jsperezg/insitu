# frozen_string_literal: true

require 'rails_helper'

describe PaymentMethod, type: :model do
  before do
    Thread.current[:user] = create(:user)
  end

  it 'Name is mandatory: Nil is not a valid value' do
    payment_method = described_class.new
    payment_method.save

    expect(payment_method.errors).to be_key :name
  end

  it 'Name is mandatory: blank is not a valid value' do
    payment_method = described_class.new(name: '')
    payment_method.save

    expect(payment_method.errors).to be_key :name
  end

  it 'name is unique' do
    described_class.create(name: 'one payment method')

    r = described_class.new(name: 'one payment method')
    r.save

    expect(r.errors).to be_key :name
  end

  describe 'default flag' do
    it 'just one payment method as default' do
      p1 = create(:payment_method, default: true)
      p1.reload
      expect(p1.default).to be_truthy

      p2 = create(:payment_method, default: true)
      p2.reload
      expect(p2.default).to be_truthy

      p1.reload
      expect(p1.default).to be_falsey
    end
  end
end
