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
end
