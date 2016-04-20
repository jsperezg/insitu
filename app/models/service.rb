class Service < AbstractSubscriptionValidator
  filterrific(
      default_filter_params: {
          sorted_by: 'code_asc'
      },
      available_filters: [
          :with_filter_criteria,
          :with_active_criteria,
          :sorted_by
      ]
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  def self.options_for_sorted_by
    [
        [ "#{ Service.human_attribute_name(:code) } (#{I18n.t('filterrific.sort_alpha_asc')})", 'code_asc'],
        [ "#{ Service.human_attribute_name(:code) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'code_desc'],
        [ "#{ Service.human_attribute_name(:description) } (#{I18n.t('filterrific.sort_alpha_asc')})", 'description_asc'],
        [ "#{ Service.human_attribute_name(:description) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'description_desc'],
        [ "#{ Service.human_attribute_name(:active) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'active_asc'],
        [ "#{ Service.human_attribute_name(:active) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'active_desc']
    ]
  end

  def self.active_filter_options
    [
      [I18n.t('services.all_records'), '0'],
      [I18n.t('services.only_inactive'), '2'],
      [I18n.t('services.only_active'), '1']
    ]
  end

  scope :with_filter_criteria, lambda { |filter|
    where('code like :filter or description like :filter', { filter: "%#{filter}%" })
  }

  scope :with_active_criteria, lambda { |filter |
    case filter
      when 2 then where(active: false)
      else where(active: true)
    end
  }

  scope :sorted_by, lambda { |sort_by|
    case sort_by
      when 'code_asc'
        order(code: :asc)

      when 'code_desc'
        order(code: :desc)

      when 'description_asc'
        order(description: :asc)

      when 'description_desc'
        order(description: :desc)

      when 'active_asc'
        order(active: :asc)

      when 'active_desc'
        order(active: :desc)

      else
        order(code: :asc)
    end
  }

  belongs_to :vat
  belongs_to :unit

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates_numericality_of :price, allow_nil: false, greater_than: 0
  validates :vat, presence: true
  validates :unit, presence: true

  after_initialize :set_default_values, if: :new_record?

  has_many :invoice_details
  has_many :estimate_details
  has_many :delivery_note_details

  before_destroy :validate_referential_integrity

  def formatted_price
    ActionController::Base.helpers.number_to_currency(self.price, :precision => 2, unit: '€', format: '%n %u')
  end

  private

  def set_default_values
    self.active = true
  end

  def validate_referential_integrity
    return true if invoice_details.count == 0 and estimate_details.count == 0 and delivery_note_details.count == 0

    errors.add(:base, I18n.t('activerecord.errors.models.service.used_elsewhere'))
    false
  end
end
