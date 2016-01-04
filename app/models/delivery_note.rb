class DeliveryNote < ActiveRecord::Base
	include SequenceGenerator

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

  after_save(on: :create) do
    unless self.date.nil?
      increase_id self
    end
  end

  private

  def set_number
    unless self.date.nil?
      self.number ||= generate_id(Thread.current[:user], self.model_name.human, self.date.year)
    end
  end

  def number_format
    unless is_number_valid?(self.number, self.date)
      errors.add(:number, I18n.t('activerecord.errors.models.delivery_note.attributes.number.invalid_format'))
    end
  end
end
