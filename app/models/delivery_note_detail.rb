class DeliveryNoteDetail < ActiveRecord::Base
  include ApartmentCacheKeyGenerator

  belongs_to :delivery_note, touch: true
  belongs_to :service
  belongs_to :invoice_detail

  validates :service_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

	def total
		price * quantity if price.present? && quantity.present?
	end
end
