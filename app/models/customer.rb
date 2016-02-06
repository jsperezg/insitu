class Customer < ActiveRecord::Base
  validates :name, presence: true
  validates :contact_email, email: { allow_blank: true }
  validates :tax_id, uniqueness: { case_sensitive: false, allow_blank: true}
  validates :irpf, numericality: { greater_than_or_equal_to: 0, only_integer: true, allow_blank: true }

  has_many :invoices, dependent: :restrict_with_error
  has_many :estimates, dependent: :restrict_with_error
  has_many :delivery_notes, dependent: :restrict_with_error
end
