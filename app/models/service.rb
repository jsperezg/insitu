class Service < ActiveRecord::Base
  belongs_to :vat
  belongs_to :unit

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates_numericality_of :price, allow_nil: false, greater_than: 0
  validates :vat, presence: true
  validates :unit, presence: true
end
