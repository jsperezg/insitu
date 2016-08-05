class Plan < ActiveRecord::Base
  filterrific(
      default_filter_params: {
          sorted_by: 'months_asc'
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
        [ "#{ Service.human_attribute_name(:description) } (#{I18n.t('filterrific.sort_alpha_asc')})", 'description_asc'],
        [ "#{ Service.human_attribute_name(:description) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'description_desc'],
        [ "#{ Service.human_attribute_name(:months) } (#{I18n.t('filterrific.sort_alpha_asc')})", 'months_asc'],
        [ "#{ Service.human_attribute_name(:months) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'months_desc'],
        [ "#{ Service.human_attribute_name(:price) } (#{I18n.t('filterrific.sort_alpha_asc')})", 'price_asc'],
        [ "#{ Service.human_attribute_name(:price) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'price_desc'],
        [ "#{ Service.human_attribute_name(:is_active) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'is_active_asc'],
        [ "#{ Service.human_attribute_name(:is_active) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'is_active_desc']
    ]
  end

  def self.active_filter_options
    [
        [I18n.t('plans.all_records'), '0'],
        [I18n.t('plans.only_inactive'), '2'],
        [I18n.t('plans.only_active'), '1']
    ]
  end

  scope :with_filter_criteria, lambda { |filter|
    where('description like :filter', filter: "%#{filter}%")
  }

  scope :with_active_criteria, lambda { |filter |
    case filter
      when 1 then where(is_active: true)
      when 2 then where(is_active: false)
    end
  }

  scope :sorted_by, lambda { |sort_by|
    case sort_by
      when 'description_asc'
        order(description: :asc)

      when 'description_desc'
        order(description: :desc)

      when 'months_asc'
        order(months: :asc)

      when 'months_desc'
        order(months: :desc)

      when 'price_asc'
        order(price: :asc)

      when 'price_desc'
        order(price: :desc)

      when 'is_active_asc'
        order(is_active: :asc)

      when 'is_active_desc'
        order(is_active: :desc)

      else
        order(code: :asc)
    end
  }

  validates :description, presence: true
  validates :price, presence: true, :numericality => { greater_than: 0 }
  validates :months, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :vat_rate, presence: true, numericality: { greater_than: 0, only_integer: true }

  after_initialize :set_default_values, if: :new_record?

  private

  def set_default_values
    self.is_active = true
  end
end
