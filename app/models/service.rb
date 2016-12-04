class Service < ActiveRecord::Base
  include ApartmentCacheKeyGenerator

  filterrific(
      default_filter_params: {
          sorted_by: 'code_asc',
          with_active_criteria: 1
      },
      available_filters: [
          :with_filter_criteria,
          :with_active_criteria,
          :sorted_by
      ]
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  def self.active_filter_options
    [
      [I18n.t('services.only_active'), '1'],
      [I18n.t('services.only_inactive'), '2']
    ]
  end

  scope :with_filter_criteria, lambda { |filter|
    where('code like :filter or description like :filter', filter: "%#{filter}%")
  }

  scope :with_active_criteria, lambda { |filter |
    case filter
      when 2 then where(active: false)
      else where(active: true)
    end
  }

  scope :sorted_by, lambda { |sort_by|
    parts = sort_by.split('_')

    if parts.empty?
      order(code:  :asc)
    elsif parts[0] == 'unit'
      joins(:unit).order("units.label_short #{ parts[1] }")
    elsif parts[0] == 'vat'
      joins(:vat).order("vats.rate #{ parts[1] }")
    else
      sort_criteria = {}
      sort_criteria[parts[0].to_sym] = parts[1].to_sym
      order(sort_criteria)
    end
  }

  belongs_to :vat
  belongs_to :unit

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates_numericality_of :price, allow_nil: false, greater_than: 0
  validates :vat, presence: true
  validates :unit, presence: true

  after_initialize :set_default_values

  has_many :invoice_details, dependent: :restrict_with_error
  has_many :estimate_details, dependent: :restrict_with_error
  has_many :delivery_note_details, dependent: :restrict_with_error
  has_many :time_logs, dependent: :restrict_with_error

  before_destroy :validate_referential_integrity

  private

  def set_default_values
    self.active = true if self.new_record?
  end

  def validate_referential_integrity
    return true if invoice_details.count == 0 and estimate_details.count == 0 and delivery_note_details.count == 0

    errors.add(:base, I18n.t('activerecord.errors.models.service.used_elsewhere'))
    false
  end
end
