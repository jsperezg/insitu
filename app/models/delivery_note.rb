class DeliveryNote < ActiveRecord::Base
	include SequenceGenerator

  	belongs_to :customer
    has_many :delivery_note_details, :dependent => :destroy

    accepts_nested_attributes_for :delivery_note_details, reject_if: proc { |attr|
      attr[:service_id].blank? and attr[:quantity].blank? and attr[:price].blank? and attr[:custom_description].blank?
    }, :allow_destroy => true

  	validates :customer_id, presence: true
  	validates :date, presence: true    

  	before_create :set_number
  	
  	after_commit(on: :create) do
  		increase_id(Thread.current[:user], self.model_name.human, self.date.year)
  	end

  	private 

  	def set_number
  		self.number = generate_id(Thread.current[:user], self.model_name.human, self.date.year)
  	end
end
