class DeliveryNoteDetail < ActiveRecord::Base
  	belongs_to :delivery_note
  	belongs_to :service

  	validates :service_id, presence: true
  	validates :quantity, presence: true, numericality: { greater_than: 0 }
  	validates :price, presence: true, numericality: { greater_than: 0 }

	def total
		price * quantity if price.present? && quantity.present?
	end
end
