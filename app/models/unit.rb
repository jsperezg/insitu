class Unit < ActiveRecord::Base
  validates :label_short, presence: true, uniqueness: true

	has_many :services, dependent: :restrict_with_error
end
