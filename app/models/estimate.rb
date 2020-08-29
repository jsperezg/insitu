# frozen_string_literal: true

# Class that represents an estimate.
class Estimate < ApplicationRecord
  include SequenceGenerator

  filterrific(
    default_filter_params: {
      sorted_by: 'date_desc'
    },
    available_filters: %i[with_number with_date_ge with_customer sorted_by]
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  belongs_to :customer
  has_many :estimate_details, dependent: :destroy
  belongs_to :estimate_status

  validates :customer_id, presence: true
  validates :date, presence: true
  validates :estimate_status_id, presence: true
  validate :validate_valid_until
  validates :number, presence: true, uniqueness: true
  validate :number_format

  accepts_nested_attributes_for :estimate_details, reject_if: proc { |attr|
    attr[:service_id].blank? &&
      attr[:quantity].blank? &&
      attr[:price].blank? &&
      attr[:description].blank?
  }, allow_destroy: true

  before_validation :set_default_values

  after_create do
    increase_id
  end

  after_update do
    unless number == number_was
      decrease_id if number_was == last_document_number
    end
  end

  after_destroy do
    decrease_id if number == last_document_number
  end

  def total
    total = 0
    estimate_details.each do |detail|
      total += detail[:quantity] * detail[:price] * (1 - (detail[:discount] / 100.0))
    end

    total
  end

  def created?
    estimate_status.nil? || estimate_status&.name == 'estimate-status.created'
  end

  def accepted?
    estimate_status&.name == 'estimate_status.accepted'
  end

  def rejected?
    (!accepted? && (valid_until.nil? || valid_until <= Date.today)) || estimate_status&.name == 'estimate_status.rejected'
  end

  def sent?
    estimate_status&.name == 'estimate_status.sent'
  end

  def sent!
    return if sent?

    self.estimate_status = EstimateStatus.find_by(name: 'estimate_status.sent')
    save!
  end

  scope :with_number, ->(number) { where('number like :number', number: "#{number}%") }

  scope :with_date_ge, lambda { |date|
    match = date.match(%r((\d{2})\/(\d{2})\/(\d{4}))i)
    date = "#{match[3]}-#{match[2]}-#{match[1]}" if match
    where('date >= :date', date: date)
  }

  scope :with_customer, ->(customer_id) { where(customer_id: customer_id) }

  scope :sorted_by, lambda { |sort_by|
    parts = sort_by.split('_')

    if parts.empty?
      order(date: :desc)
    elsif parts[0] == 'customer'
      joins(:customer).order("customers.name #{parts[1]}")
    else
      sort_criteria = {}
      sort_criteria[parts[0].parameterize.underscore.to_sym] = parts[1].to_sym
      order(sort_criteria)
    end
  }

  private

  def set_default_values
    self.estimate_status_id ||= EstimateStatus.find_by(name: 'estimate_status.created')&.id
    self.date ||= Date.today
    self.number ||= generate_id(model_name.human, date.year)
  end

  def validate_valid_until
    return unless !valid_until.nil? && !date.nil? && (valid_until < date)

    errors.add(:valid_until, I18n.t('activerecord.errors.models.estimate.attributes.valid_until.invalid_value'))
  end

  def number_format
    return if number_valid?(self.date)

    year = self.date&.year || Date.today.year
    errors.add(:number, I18n.t('activerecord.errors.models.estimate.attributes.number.invalid_format', year: year))
  end

  def last_document_number
    return if date.nil?

    last_id(model_name.human, date.year)
  end
end
