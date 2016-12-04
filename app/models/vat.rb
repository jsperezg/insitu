class Vat < ActiveRecord::Base
	include ApartmentCacheKeyGenerator

	has_many :services, dependent: :restrict_with_error

	validates :label, presence: true
	validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }, uniqueness: true

	after_save :maintain_default_flag

	private

	def maintain_default_flag
		if self.default
			Vat.where(default: true).where.not(id: self.id).each do |vat|
				vat.update(default: false)
			end
		end
	end
end
