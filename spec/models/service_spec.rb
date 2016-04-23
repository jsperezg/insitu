require 'rails_helper'

RSpec.describe Service, type: :model do
  before(:all) do
    @user_sequence = rand(10000) if @user_sequence.nil?
    @user_sequence += 1

    Thread.current[:user] = create(:user, email: "user_#{@user_sequence}@domain.com")
    Vat.first || create(:vat)
    Unit.first || create(:unit)
  end

  it 'code is mandatory' do
    service = Service.new(
      description: 'It has a description',
      price: 1.0,
      vat: Vat.first,
      unit: Unit.first
    )
    service.save

    expect(service.errors).to satisfy { |errors| !errors.empty? && errors.key?( :code )}
  end

  it 'code is unique' do
    Service.create!(
      code:  'a code',
      description: 'It has a description',
      price: 1.0,
      vat: Vat.first,
      unit: Unit.first
    )

    another_service = Service.new(
      code:  'a code',
      description: 'It has a description',
      price: 1.0,
      vat: Vat.first,
      unit: Unit.first
    )
    another_service.save

    expect(another_service.errors).to satisfy { |errors| !errors.empty? && errors.key?( :code )}
  end

  it 'description is mandatory' do
    service = Service.new(
      code: 'a code',
      price: 1.0,
      vat: Vat.first,
      unit: Unit.first
    )
    service.save

    expect(service.errors).to satisfy { |errors| !errors.empty? && errors.key?( :description )}
  end

  it 'price is mandatory' do
    service = Service.new(
      code:  'a code',
      description: 'It has a description',
      vat: Vat.first,
      unit: Unit.first
    )
    service.save

    expect(service.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}

  end

  it 'price is positive' do
    service = Service.new(
      code:  'a code',
      description: 'It has a description',
      price: -1,
      vat: Vat.first,
      unit: Unit.first
    )
    service.save

    expect(service.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}
  end

  it 'vat is mandatory' do
    service = Service.new(
      code:  'a code',
      description: 'It has a description',
      price: 1,
      unit: Unit.first
    )
    service.save

    expect(service.errors).to satisfy { |errors| !errors.empty? && errors.key?( :vat )}

  end

  it 'unit is mandatory' do
    service = Service.new(
      code:  'a code',
      description: 'It has a description',
      price: 1,
      vat: Vat.first
    )
    service.save

    expect(service.errors).to satisfy { |errors| !errors.empty? && errors.key?( :unit )}
  end

  it 'active defaults to true' do
    service = Service.new(
        code:  'a code',
        description: 'It has a description',
        price: 1,
        unit: Unit.first,
        vat: Vat.first
    )
    expect(service.save).to be_truthy

    service.reload
    expect(service.active).to be_truthy
  end

  it 'expired user cant save delivery notes' do
    Thread.current[:user] = create(:expired_user)
    object = Service.new
    object.save

    expect(object.errors).to satisfy { |errors| !errors.empty? && errors.key?( :base )}
    expect(object.errors[:base]).to include(I18n.t('activerecord.errors.messages.subscription_expired'))
  end
end
