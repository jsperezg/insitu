class Customer < ActiveRecord::Base
  validates :name, presence: true
end
