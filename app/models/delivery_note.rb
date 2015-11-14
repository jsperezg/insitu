class DeliveryNote < ActiveRecord::Base
	include SequenceGenerator

  	belongs_to :customer

  	validates :customer_id, presence: true
  	validates :date, presence: true

  	before_create :set_number

  	private 

  	def set_number
  		self.number = generate_id(Thread.current[:user], self.model_name.human, date.year)
  	end
end
