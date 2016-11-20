class Vat < ActiveRecord::Base
	include ApartmentCacheKeyGenerator

	validates :label, presence: true
	validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }, uniqueness: true

	after_save :maintain_default_flag

	private

	def maintain_default_flag
		if self.default
			Vat.where(default: true).where.not(id: self.id).update_all(default: false)
		end
	end
end
