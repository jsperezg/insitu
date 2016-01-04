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
  validates :number, presence: true, uniqueness: true
  validate :number_format

  accepts_nested_attributes_for :invoice_details, reject_if: proc { |attr|
    result = true

    [:date, :payment_method_id, :customer_id, :payment_date, :price, :quantity].each do |attr_id|
      result = false unless attr[attr_id].blank?
    end

    result
  }, :allow_destroy => true

  after_initialize :set_default_values
  before_validation :set_default_values
  before_validation :set_invoice_number

  after_save(on: :create) do
    increase_id self
  end

  private

  def set_default_values
    self.invoice_status_id ||= InvoiceStatus.find_by(name: 'invoice_status.created').try(:id)
  end

  def set_invoice_number
    unless self.date.nil?
      if self.customer.try(:billing_serie).blank?
        self.number ||= generate_id(Thread.current[:user], self.model_name.human, self.date.year)
      else
        self.number ||= generate_id(Thread.current[:user], self.customer.billing_serie.capitalize, self.date.year)
      end
    end
  end

  def number_format
    unless is_number_valid?(self.number, self.date)
      errors.add(:number, I18n.t('activerecord.errors.models.invoice.attributes.number.invalid_format'))
    end
  end
end
