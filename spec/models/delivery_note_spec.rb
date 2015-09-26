require 'rails_helper'

RSpec.describe DeliveryNote, type: :model do
  it "customer is mandatory" do
    deliver_note = DeliveryNote.new
    deliver_note.save

    expect(deliver_note.errors).to satisfy { |errors| !errors.empty? && errors.key?( :customer_id )}
  end

  it "date is mandatory" do
    deliver_note = DeliveryNote.new
    deliver_note.save

    expect(deliver_note.errors).to satisfy { |errors| !errors.empty? && errors.key?( :date )}
  end
end
