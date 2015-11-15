class DeliveryNoteDetail < ActiveRecord::Base
  	belongs_to :delivery_note
  	belongs_to :service

	def total
		price * quantity
	end
end
