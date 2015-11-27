class Invoice < ActiveRecord::Base
    belongs_to :payment_method
    belongs_to :customer
    has_many :invoice_details, :dependent => :destroy
    
    validates :date, presence: true
    validates :payment_method_id, presence: true
    validates :customer_id, presence: true
    validates :payment_date, presence: true

    accepts_nested_attributes_for :invoice_details, reject_if: proc { |attr|
      [:date, :payment_method_id, :customer_id, :payment_date].each do |attr_id|
        return false unless attr[attr_id].blank?
      end

      true
    }, :allow_destroy => true

    before_create :set_number

    after_commit(on: :create) do
      increase_id(Thread.current[:user], self.model_name.human, self.date.year)
    end

  	private 

  	def set_number
  		self.number = generate_id(Thread.current[:user], self.model_name.human, date.year)
  	end
end
