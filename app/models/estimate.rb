class Estimate < ActiveRecord::Base
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

  belongs_to :customer
  has_many :estimate_details, :dependent => :destroy
  belongs_to :estimate_status

  validates :customer_id, presence: true
  validates :date, presence: true
  validates :estimate_status_id, presence: true
  validate :validate_valid_until
  validates :number, presence: true, uniqueness: true
  validate :number_format

  accepts_nested_attributes_for :estimate_details, reject_if: proc { |attr|
    result = true

    [:service_id, :quantity, :price].each do |attr_id|
      result = false unless attr[attr_id].blank?
    end

    result
  }, :allow_destroy => true

  after_initialize :set_default_values, if: :new_record?
  before_validation :set_default_values

  after_save do
    increase_id self
  end

  def total
    total = 0
    self.estimate_details.each do |detail|
      total += detail[:quantity] * detail[:price] * (1 - (detail[:discount] / 100.0))
    end

    total
  end

  def created?
    self.estimate_status.nil? || self.estimate_status.try(:name) == 'estimate-status.created'
  end

  def accepted?
    self.estimate_status.try(:name) == 'estimate_status.accepted'
  end

  def rejected?
    (!self.accepted? && (valid_until.nil? || valid_until <= Date.today)) || self.estimate_status.try(:name) == 'estimate_status.rejected'
  end

  def sent?
    self.estimate_status.try(:name) == 'estimate_status.sent'
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
    self.estimate_status_id ||= EstimateStatus.find_by(name: 'estimate_status.created').try(:id)

    unless self.date.nil?
      self.number ||= generate_id(self.model_name.human, self.date.year)
    end

    self.date ||= Date.today
  end

  def validate_valid_until
    if !valid_until.nil? and !date.nil? and valid_until < date
      errors.add(:valid_until, I18n.t('activerecord.errors.models.estimate.attributes.valid_until.invalid_value'))
    end
  end

  def number_format
    unless is_number_valid?(self.number, self.date)
      year = self.date.try(:year) || Date.today.year
      errors.add(:number, I18n.t('activerecord.errors.models.estimate.attributes.number.invalid_format', year: year ))
    end
  end
end
