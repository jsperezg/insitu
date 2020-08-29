# frozen_string_literal: true

# Class that represents an invoice.
class Invoice < ActiveRecord::Base
  include SequenceGenerator

  filterrific(
    default_filter_params: {
      sorted_by: 'date_desc'
    },
    available_filters: %i[with_number with_date_ge with_customer sorted_by]
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  belongs_to :payment_method
  belongs_to :customer
  belongs_to :invoice_status
  has_many :invoice_details, dependent: :destroy

  has_many :amending_invoices, class_name: 'Invoice', foreign_key: 'amended_invoice_id'
  belongs_to :amended_invoice, class_name: 'Invoice'

  validates :date, presence: true
  validates :payment_method_id, presence: true, unless: :amending_invoice?
  validates :customer_id, presence: true
  validates :payment_date, presence: true, unless: :amending_invoice?
  validates :invoice_status_id, presence: true
  validates :number, presence: true, uniqueness: true
  validate :number_format
  validate :valid_customer

  accepts_nested_attributes_for :invoice_details, reject_if: proc { |attr|
    result = true

    attrs = %i[date payment_method_id customer_id payment_date price quantity]
    attrs.each do |id|
      result = false unless attr[id].blank?
    end

    result
  }, allow_destroy: true

  after_initialize :set_default_values
  before_validation :set_default_values
  before_validation :set_invoice_number

  after_create do
    increase_id
  end

  after_update do
    unless number == number_was
      decrease_id if number_was == last_invoice_number
    end
  end

  after_destroy do
    decrease_id
  end

  def total
    result = 0

    invoice_details.each do |detail|
      result += detail.total
    end

    result - applied_irpf
  end

  def subtotal
    result = 0

    invoice_details.each do |detail|
      result += detail.subtotal
    end

    result
  end

  def tax
    result = {
    }

    invoice_details.each do |detail|
      result[detail.vat_rate] = 0 unless result.key?(detail.vat_rate)
      result[detail.vat_rate] += detail.tax
    end

    result
  end

  def accumulated_tax
    result = 0

    invoice_details.each do |detail|
      result += detail.tax
    end

    result
  end

  def discount
    result = 0

    invoice_details.each do |detail|
      result += detail.applied_discount
    end

    result
  end

  def applied_irpf
    result = 0
    gross_amount = subtotal - discount
    irpf_value = irpf || 0
    result = gross_amount * irpf_value / 100.0 if irpf_value.positive?

    result
  end

  def apply_irpf(user)
    self.irpf = customer&.irpf || 0
    self.irpf = 0 if user.cif?
  end

  def created?
    invoice_status.nil? || invoice_status.name == 'invoice_status.created'
  end

  def sent?
    invoice_status&.name == 'invoice_status.sent'
  end

  def paid?
    invoice_status&.name == 'invoice_status.paid' || !paid_on.nil?
  end

  def default?
    invoice_status&.name == 'invoice_status.default' || (!created? && payment_date < Date.today)
  end

  def amending_invoice?
    !amended_invoice_id.nil?
  end

  scope :with_number, ->(number) { where('number like ?', "#{number}%") }
  scope :with_customer, ->(customer_id) { where(customer_id: customer_id) }

  scope :with_date_ge, lambda { |date|
    match = date.match(%r((\d{2})\/(\d{2})\/(\d{4}))i)
    date = "#{match[3]}-#{match[2]}-#{match[1]}" if match

    where('date >= ?', date)
  }

  scope :sorted_by, lambda { |sort_by|
    parts = sort_by.split('_')

    if parts.empty?
      order(date:  :desc)
    elsif parts[0] == 'customer'
      joins(:customer).order("customers.name #{parts[1]}")
    else
      sort_criteria = {}
      sort_criteria[parts[0].parameterize.underscore.to_sym] = parts[1].to_sym
      order(sort_criteria)
    end
  }

  def destroy
    raise I18n.t('activerecord.errors.models.invoice.deletion_is_not_allowed') unless deletion_allowed?

    super
  end

  def deletion_allowed?
    number == last_invoice_number && !paid?
  end

  private

  def set_default_values
    if !paid? && paid_on.present?
      self.invoice_status_id = InvoiceStatus.paid&.id
    elsif default?
      self.invoice_status_id = InvoiceStatus.default&.id
    else
      self.invoice_status_id ||= InvoiceStatus.created&.id
    end

    # By default: payment date is the invoice date + 15 days.
    self.payment_date = date + 15.days if date.present? && !payment_date.present?

    # Establish the default payment method
    self.payment_method_id ||= PaymentMethod.default&.id

    self.irpf = 0 if irpf.nil?
  end

  def set_invoice_number
    self.number ||= next_invoice_number
  end

  def next_invoice_number
    return if date.nil?

    generate_id(billing_series, date.year)
  end

  def last_invoice_number
    return if date.nil?

    last_id(billing_series, date.year)
  end

  def billing_series
    return AMENDING_INVOICE_SERIES if amending_invoice?
    return customer.billing_serie.capitalize unless customer&.billing_serie.blank?

    model_name.human
  end

  def number_format
    return if number_valid?(date)

    year = date&.year || Date.today.year
    errors.add(:number, I18n.t('activerecord.errors.models.invoice.attributes.number.invalid_format', year: year))
  end

  def valid_customer
    return unless customer.present? && !customer.can_invoice?

    errors.add(:customer_id, I18n.t('activerecord.errors.models.invoice.attributes.customer_id.invalid_format'))
  end
end
