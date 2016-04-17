class Unit < ActiveRecord::Base
	validates :label_short, presence: true, uniqueness: true

	has_many :services

  before_destroy :validate_referential_integrity

  private

  def validate_referential_integrity
    return true if services.count == 0

    errors.add(:base, I18n.t('activerecord.errors.models.unit.used_elsewhere'))
    false
  end
end
