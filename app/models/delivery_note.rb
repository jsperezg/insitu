# frozen_string_literal: true

# Class represents a delivery note.
class DeliveryNote < ApplicationRecord
  include SequenceGenerator

  filterrific(
    default_filter_params: {
      sorted_by: 'date_desc'
    },
    available_filters: %i[with_number with_date_ge with_customer sorted_by]
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  belongs_to :customer
  has_many :delivery_note_details, dependent: :destroy

  accepts_nested_attributes_for :delivery_note_details, reject_if: proc { |attr|
    attr[:service_id].blank? &&
      attr[:quantity].blank? &&
      attr[:price].blank? &&
      attr[:description].blank?
  }, allow_destroy: true

  validates :customer, presence: true
  validates :date, presence: true
  validates :number, presence: true, uniqueness: true
  validate :number_format

  before_validation :set_number

  after_create do
    increase_id unless date.nil?
  end

  after_update do
    unless number == number_before_last_save
      decrease_id if number_before_last_save == last_document_number
    end
  end

  after_destroy do
    decrease_id if number == last_document_number
  end

  def total
    result = 0

    delivery_note_details.each do |detail|
      result += detail.total
    end

    result
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

  def set_number
    return if date.nil?

    self.number ||= generate_id(model_name.human, date.year)
  end

  def number_format
    return if number_valid?(date)

    year = date&.year || Date.today.year
    errors.add(:number, I18n.t('activerecord.errors.models.delivery_note.attributes.number.invalid_format', year: year))
  end

  def last_document_number
    return if date.nil?

    last_id(model_name.human, date.year)
  end
end
