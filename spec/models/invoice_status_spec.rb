require 'rails_helper'

RSpec.describe InvoiceStatus, type: :model do
  it 'name is mandatory' do
    status = InvoiceStatus.new
    status.save

    expect(status.errors).to satisfy { |errors| errors.key? :name }
  end
end
