require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  it "Name is mandatory: Nil is not a valid value" do
    payment_method = PaymentMethod.new
    payment_method.save

    expect(payment_method.errors).to satisfy { |errors| !errors.empty? && errors.key?( :name )}
  end

  it "Name is mandatory: blank is not a valid value" do
    payment_method = PaymentMethod.new(name: '')
    payment_method.save

    expect(payment_method.errors).to satisfy { |errors| !errors.empty? && errors.key?( :name )}
  end

  it 'name is unique' do
    PaymentMethod.create(name: 'one payment method')

    r = PaymentMethod.new(name: 'one payment method')
    r.save

    expect(r.errors).to satisfy { |errors| errors.key? :name }
  end
end
