# frozen_string_literal: true

# Entity that maintains the available VAT rates for a user.
class Vat < ActiveRecord::Base
  has_many :services, dependent: :restrict_with_error

  validates :label, presence: true
  validates :rate,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, only_integer: true },
            uniqueness: true

  after_save :maintain_default_flag

  def self.default
    Vat.find_by(default: true)
  end

  private

  def maintain_default_flag
    return unless default
    Vat.where(default: true).where.not(id: id).each do |vat|
      vat.update(default: false)
    end
  end
end
