require 'rails_helper'

RSpec.describe Customer, type: :model do
  it 'name is mandatory' do
    customer = Customer.new
    customer.save

    expect(customer.errors).to satisfy { |errors| !errors.empty? && errors.key?( :name )}
  end
end
