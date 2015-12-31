class Invoice < ActiveRecord::Base
    include SequenceGenerator

    belongs_to :payment_method
    belongs_to :customer
    belongs_to :invoice_status
    has_many :invoice_details, :dependent => :destroy

    validates :date, presence: true
    validates :payment_method_id, presence: true
    validates :customer_id, presence: true
    validates :payment_date, presence: true
    validates :invoice_status_id, presence: true

    accepts_nested_attributes_for :invoice_details, reject_if: proc { |attr|
      result = true

      [:date, :payment_method_id, :customer_id, :payment_date, :price, :quantity].each do |attr_id|
        result = false unless attr[attr_id].blank?
      end

      result
    }, :allow_destroy => true

    before_validation :set_default_values

    after_commit(on: :create) do
      increase_id(Thread.current[:user], self.model_name.human, self.date.year)
    end

  	private

  	def set_default_values
      self.invoice_status_id ||= InvoiceStatus.find_by(name: 'invoice_status.created').try(:id)

      unless self.date.nil?
        self.number ||= generate_id(Thread.current[:user], self.model_name.human, self.date.year)
      end
  	end
end
