class DeliveryNote < AbstractSubscriptionValidator
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
  has_many :delivery_note_details, :dependent => :destroy

  accepts_nested_attributes_for :delivery_note_details, reject_if: proc { |attr|
    attr[:service_id].blank? and attr[:quantity].blank? and attr[:price].blank? and attr[:custom_description].blank?
  }, :allow_destroy => true

  validates :customer_id, presence: true
  validates :date, presence: true
  validates :number, presence: true, uniqueness: true
  validate :number_format

  before_validation :set_number

  after_save do
    unless self.date.nil?
      increase_id self
    end
  end

  def total
    result = 0

    delivery_note_details.each do |detail|
      result += detail.total
    end

    result
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

  def set_number
    unless self.date.nil?
      self.number ||= generate_id(self.model_name.human, self.date.year)
    end
  end

  def number_format
    unless is_number_valid?(self.number, self.date)
      year = self.date.try(:year) || Date.today.year
      errors.add(:number, I18n.t('activerecord.errors.models.delivery_note.attributes.number.invalid_format', year: year))
    end
  end
end
