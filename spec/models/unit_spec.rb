require 'rails_helper'

RSpec.describe Unit, type: :model do
  before(:each) do
    Thread.current[:user] = create(:user)
  end

  it 'short label is mandatory' do
  	unit = Unit.new
  	unit.save

  	expect(unit.errors).to satisfy { |errors| !errors.empty? && errors.key?( :label_short )}
  end

  it 'short label is unique' do
    Unit.create!(label_short: 'U')

    u = Unit.create(label_short: 'U')
    u.save

    expect(u.errors).to satisfy { |errors| errors.key? :label_short }
  end

  it 'expired user cant save delivery notes' do
    Thread.current[:user] = create(:expired_user)
    object = Unit.new
    object.save

    expect(object.errors).to satisfy { |errors| !errors.empty? && errors.key?( :base )}
    expect(object.errors[:base]).to include(I18n.t('activerecord.errors.messages.subscription_expired'))
  end
end
