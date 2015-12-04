require 'rails_helper'

RSpec.describe Unit, type: :model do
  it 'short label is mandatory' do
  	unit = Unit.new
  	unit.save

  	expect(unit.errors).to satisfy { |errors| !errors.empty? && errors.key?( :label_short )}
  end
end
