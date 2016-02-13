class Service < ActiveRecord::Base
  filterrific(
      default_filter_params: {
          sorted_by: 'code_asc'
      },
      available_filters: [
          :with_filter_criteria,
          :sorted_by
      ]
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  def self.options_for_sorted_by
    [
        [ "#{ Service.human_attribute_name(:code) } (#{I18n.t('filterrific.sort_alpha_asc')})", 'code_asc'],
        [ "#{ Service.human_attribute_name(:code) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'code_desc'],
        [ "#{ Service.human_attribute_name(:description) } (#{I18n.t('filterrific.sort_alpha_asc')})", 'description_asc'],
        [ "#{ Service.human_attribute_name(:description) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'description_desc']
    ]
  end

  scope :with_filter_criteria, lambda { |filter|
    where('code like :filter or description like :filter', { filter: "%#{filter}%" })
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
end
