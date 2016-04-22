require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  before(:each) do
    Thread.current[:user] = create(:user)
  end

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

  it 'expired user cant save delivery notes' do
    Thread.current[:user] = create(:expired_user)
    object = PaymentMethod.new
    object.save

    expect(object.errors).to satisfy { |errors| !errors.empty? && errors.key?( :base )}
    expect(object.errors[:base]).to include(I18n.t('activerecord.errors.messages.subscription_expired'))
  end
end
