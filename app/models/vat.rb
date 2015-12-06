class Vat < ActiveRecord::Base
	validates :label, presence: true
	validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
