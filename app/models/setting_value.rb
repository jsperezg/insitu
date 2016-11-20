class SettingValue < ActiveRecord::Base
  include ApartmentCacheKeyGenerator

  belongs_to :setting_key

  validates :setting_key, presence: true
end
