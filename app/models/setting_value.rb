class SettingValue < ActiveRecord::Base
  belongs_to :setting_key

  validates :setting_key, presence: true
end
