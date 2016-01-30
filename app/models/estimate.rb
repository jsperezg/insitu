class Estimate < ActiveRecord::Base
  include SequenceGenerator

  belongs_to :customer
  has_many :estimate_details, :dependent => :destroy

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

  after_initialize :set_default_values
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
