require 'rails_helper'

RSpec.describe DeliveryNote, type: :model do
  before(:each) do
    Thread.current[:user] = User.first || create(:user)
  end

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

  describe 'Delivery note serie' do
    it 'generic serie' do
      delivery_note = create(:delivery_note)

      delivery_note.reload

      expect(delivery_note.errors.empty?).to be(true)
      expect(delivery_note.number).to start_with(DeliveryNote.model_name.human[0].capitalize)
    end

    it 'do not allow duplicates' do
      delivery_note = build(:delivery_note, number: "I/#{ Date.today.year }/000001")
      delivery_note.save

      expect(delivery_note.errors.empty?).to be(true)

      another_delivery_note = build(:delivery_note, number: "I/#{ Date.today.year }/000001")
      another_delivery_note.save

      expect(another_delivery_note.errors).to satisfy { |errors| errors.key? :number }
    end

    it 'update default serie for estimates' do
      delivery_note = build(:delivery_note, number: "X/#{ Date.today.year }/000001")
      delivery_note.save

      expect(delivery_note.errors.empty?).to be(true)

      another_delivery_note = create(:delivery_note)
      another_delivery_note.reload

      expect(another_delivery_note.number).to eq("X/#{ Date.today.year }/000002")
    end
  end

  describe 'Number format validation' do
    it 'First capital letter' do
      delivery_note = build(:delivery_note, number: "i/#{ Date.today.year }/000001")
      delivery_note.save

      expect(delivery_note.errors).to satisfy { |errors| errors.key? :number }
    end

    it 'Same year as bill' do
      delivery_note = build(:delivery_note, number: "i/#{ Date.today.year + 1 }/000001")
      delivery_note.save

      expect(delivery_note.errors).to satisfy { |errors| errors.key? :number }
    end

    it '6 digits' do
      delivery_note = build(:delivery_note, number: "i/#{ Date.today.year}/xxxxxx")
      delivery_note.save

      expect(delivery_note.errors).to satisfy { |errors| errors.key? :number }
    end
  end

  it 'valid delivery  notes' do
    10.times do
      delivery_note = build(:delivery_note)
      delivery_note.save

      expect(delivery_note.errors.empty?).to be(true)
    end
  end
end
