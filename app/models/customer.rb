class Customer < ActiveRecord::Base
  validates :name, presence: true
  validates :contact_email, email: { allow_blank: true }
  validates :tax_id, uniqueness: { case_sensitive: false, allow_blank: true}
end
