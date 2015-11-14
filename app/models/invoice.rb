class Invoice < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :customer
  
  validates :date, presence: true
  validates :payment_method_id, presence: true
  validates :customer_id, presence: true
  validates :issue_date, presence: true
  validates :payment_date, presence: true

  before_create :set_number

  	private 

  	def set_number
  		self.number = generate_id(Thread.current[:user], self.model_name.human, date.year)
  	end
end
