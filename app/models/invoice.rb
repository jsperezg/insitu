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

  after_save do
    increase_id self
  end

  def total
    result = 0

    self.invoice_details.each do |detail|
      result += detail.total
    end

    result - applied_irpf
  end

  def subtotal
    result = 0

    self.invoice_details.each do |detail|
      result += detail.subtotal
    end

    result
  end

  def tax
    result = 0

    self.invoice_details.each do |detail|
      result += detail.tax
    end

    result
  end

  def discount
    result = 0

    self.invoice_details.each do |detail|
      result += detail.applied_discount
    end

    result
  end

  def applied_irpf
    result = 0
    gross_ammount = subtotal - discount
    irpf_value = irpf || 0
    if irpf_value > 0
      result = gross_ammount * irpf / 100.0
    end

    result
  end

  def apply_irpf(user)
    self.irpf = self.customer.irpf || 0
    self.irpf = 0 unless user.try(:country) == 'ES'
  end

  private

  def set_default_values
    self.invoice_status_id ||= InvoiceStatus.find_by(name: 'invoice_status.created').try(:id)
  end

  def set_invoice_number
    unless self.date.nil?
      if self.customer.try(:billing_serie).blank?
        self.number ||= generate_id(self.model_name.human, self.date.year)
      else
        self.number ||= generate_id(self.customer.billing_serie.capitalize, self.date.year)
      end
    end
  end

  def number_format
    unless is_number_valid?(self.number, self.date)
      year = self.date.try(:year) || Date.today.year
      errors.add(:number, I18n.t('activerecord.errors.models.invoice.attributes.number.invalid_format', year: year))
    end
  end
end
