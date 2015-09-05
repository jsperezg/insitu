class Service < ActiveRecord::Base
  belongs_to :vat
  belongs_to :unit

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :price, presence: true
  validates :vat, presence: true
  validates :unit, presence: true
end
