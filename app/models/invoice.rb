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
    validate :validate_payment_date
    validate :validate_paid_on

    accepts_nested_attributes_for :invoice_details, reject_if: proc { |attr|
      result = true

      [:date, :payment_method_id, :customer_id, :payment_date, :price, :quantity, :discount].each do |attr_id|
        result = false unless attr[attr_id].blank?
      end

      result
    }, :allow_destroy => true

    before_create :set_default_values

    after_commit(on: :create) do
      increase_id(Thread.current[:user], self.model_name.human, self.date.year)
    end

  	private

  	def set_default_values
      if self.invoice_status_id.nil?
        self.invoice_status_id = InvoiceStatus.find_by(name: 'invoice_status.created').try(:id)
      end

      if (self.number.blank?)
        self.number = generate_id(Thread.current[:user], self.model_name.human, date.year)
      end
  	end

    def validate_payment_date
      if !self[:date].nil? and !self[:payment_date].nil? and self[:date] > self[:payment_date]
        errors.add(:payment_date, I18n.t('activerecord.errors.models.invoice.payment_date.invalid_value'))
      end
    end

    def validate_paid_on
      if !self[:date].nil? and !self[:paid_on].nil? and self[:date] > self[:paid_on]
        errors.add(:paid_on, I18n.t('activerecord.errors.models.invoice.paid_on.invalid_value'))
      end
    end
end
