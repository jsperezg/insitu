class Customer < ActiveRecord::Base
  filterrific(
      default_filter_params: {
          sorted_by: 'name_asc'
      },
      available_filters: [
          :with_filter_criteria,
          :sorted_by
      ]
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  def self.options_for_sorted_by
    [
        [I18n.t('filterrific.sort_by_name_desc'), 'name_desc'],
        [I18n.t('filterrific.sort_by_name_asc'), 'name_asc']
    ]
  end

  scope :with_filter_criteria, lambda { |filter|
    where('name like :filter or contact_name like :filter or contact_email like :filter', { filter: "%#{filter}%" })
  }

  scope :sorted_by, lambda { |sort_by|
    case sort_by
      when 'name_asc'
        order(name: :asc)

      when 'name_desc'
        order(name: :desc)

      else
        order(name: :asc)
    end
  }

  validates :name, presence: true
  validates :contact_email, email: { allow_blank: true }
  validates :tax_id, uniqueness: { case_sensitive: false, allow_blank: true}
  validates :irpf, numericality: { greater_than_or_equal_to: 0, only_integer: true, allow_blank: true }

  has_many :invoices, dependent: :restrict_with_error
  has_many :estimates, dependent: :restrict_with_error
  has_many :delivery_notes, dependent: :restrict_with_error
end
