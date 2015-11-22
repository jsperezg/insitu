require 'rails_helper'

RSpec.describe DeliveryNoteDetail, type: :model do	
	it "service_id is mandatory" do
		deliver_note_detail = DeliveryNoteDetail.new
		deliver_note_detail.save

		expect(deliver_note_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :service_id )}
	end

  	describe "quantity" do
  		it "is mandatory" do
  			deliver_note_detail = DeliveryNoteDetail.new
			deliver_note_detail.save

			expect(deliver_note_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :quantity )}
		end

		it "must be a number" do
  			deliver_note_detail = DeliveryNoteDetail.new(quantity: 'asdf')
			deliver_note_detail.save

			expect(deliver_note_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :quantity )}
		end

		it "is greater than zero" do
  			deliver_note_detail = DeliveryNoteDetail.new(quantity: 0)
			deliver_note_detail.save

			expect(deliver_note_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :quantity )}
		end
	end

	describe "price" do
  		it "is mandatory" do
  			deliver_note_detail = DeliveryNoteDetail.new
			deliver_note_detail.save

			expect(deliver_note_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}
		end

		it "must be a number" do
  			deliver_note_detail = DeliveryNoteDetail.new(price: 'asdf')
			deliver_note_detail.save

			expect(deliver_note_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}
		end

		it "is greater than zero" do
  			deliver_note_detail = DeliveryNoteDetail.new(price: 0)
			deliver_note_detail.save

			expect(deliver_note_detail.errors).to satisfy { |errors| !errors.empty? && errors.key?( :price )}
		end
	end
end
