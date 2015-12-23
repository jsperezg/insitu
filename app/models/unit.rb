class Unit < ActiveRecord::Base
	validates :label_short, presence: true, uniqueness: true
end
