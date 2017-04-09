# Customer model.
class Customer < ApplicationRecord
  filterrific(
    default_filter_params: {
      sorted_by: 'name_asc'
    },
    available_filters: %i(
      with_filter_criteria
      sorted_by
    )
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  scope :with_filter_criteria, lambda { |filter|
    where('name like :filter or contact_name like :filter or contact_email like :filter or send_invoices_to like :filter', filter: "%#{filter}%")
  }

  scope :sorted_by, lambda { |sort_by|
    parts = sort_by.split('_')
    if parts.empty?
      order(name: :asc)
    else
      sort_criteria = {}
      sort_criteria[parts[0].parameterize.underscore.to_sym] = parts[1].to_sym
      order(sort_criteria)
    end
  }

  validates :name, presence: true
  validates :contact_email, email: { allow_blank: true }
  validates :send_invoices_to, email: { allow_blank: true }
  validates :tax_id, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :irpf, numericality: { greater_than_or_equal_to: 0, only_integer: true, allow_blank: true }

  has_many :invoices, dependent: :restrict_with_error
  has_many :estimates, dependent: :restrict_with_error
  has_many :delivery_notes, dependent: :restrict_with_error
  has_many :projects, dependent: :restrict_with_error

  before_destroy :validate_referential_integrity

  def country_name
    unless country.blank?
      value = ISO3166::Country[country]
      value.translations[I18n.locale.to_s] || value.name
    end
  end

  def can_invoice?
    tax_id.present? &&
      name.present? &&
      address.present? &&
      postal_code.present? &&
      country.present?
  end

  def validate_referential_integrity
    return true if
      invoices.count.zero? &&
      estimates.count.zero? &&
      delivery_notes.count.zero?

    errors.add(:base,
               I18n.t('activerecord.errors.models.customer.used_elsewhere'))

    throw(:abort)
  end
end
