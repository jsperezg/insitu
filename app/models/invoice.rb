class Invoice < ActiveRecord::Base
  include SequenceGenerator

  filterrific(
      default_filter_params: {
          sorted_by: 'date_desc'
      },
      available_filters: [
          :with_number,
          :with_date_ge,
          :with_customer,
          :sorted_by
      ]
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  def self.options_for_sorted_by
    [
        [I18n.t('filterrific.sort_by_date_desc'), 'date_desc']
    ]
  end

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
  validate :valid_customer

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
    result = {
    }

    self.invoice_details.each do |detail|
      result[detail.vat_rate] = 0 unless result.key?(detail.vat_rate)
      result[detail.vat_rate] += detail.tax
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
    gross_amount = subtotal - discount
    irpf_value = irpf || 0
    if irpf_value > 0
      result = gross_amount * irpf / 100.0
    end

    result
  end

  def apply_irpf(user)
    self.irpf = self.customer.try(:irpf) || 0
    self.irpf = 0 unless user.try(:country) == 'ES'
  end

  def created?
    self.invoice_status.nil? || self.invoice_status.name == 'invoice_status.created'
  end

  def sent?
    self.invoice_status.try(:name) == 'invoice_status.sent'
  end

  def paid?
    self.invoice_status.try(:name) == 'invoice_status.paid'
  end

  def default?
    self.invoice_status.try(:name) == 'invoice_status.default' || (!created? && self.payment_date < Date.today)
  end

  scope :with_number, lambda { |number|
    where('number like :number', { number: "#{number}%" })
  }

  scope :with_date_ge, lambda { |date|
    match = date.match(/(\d{2})\/(\d{2})\/(\d{4})/i)
    if match
      date = "#{match[3]}-#{match[2]}-#{match[1]}"
    end

    where("date >= :date", { date: date })
  }

  scope :with_customer, lambda { |customer_id|
    where(customer_id: customer_id)
  }

  scope :sorted_by, lambda { |sort_by|
    case sort_by
      when 'date_desc'
        order(date: :desc)

      else
        order(date: :desc)
    end
  }

  private

  def set_default_values
    if !self.paid? && self.paid_on.present?
      self.invoice_status_id = InvoiceStatus.find_by(name: 'invoice_status.paid').try(:id)
    elsif self.default?
      self.invoice_status_id = InvoiceStatus.find_by(name: 'invoice_status.default').try(:id)
    else
      self.invoice_status_id ||= InvoiceStatus.find_by(name: 'invoice_status.created').try(:id)
    end

    # By default: payment date is the invoice date + 15 days.
    self.payment_date = self.date + 15.days if self.date.present? and !self.payment_date.present?
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

  def valid_customer
    if self.customer.present? and !customer.can_invoice?
      errors.add(:customer_id, I18n.t('activerecord.errors.models.invoice.attributes.customer_id.invalid_format'))
    end
  end
end
