class SettingValue < ActiveRecord::Base
  belongs_to :setting_key
  belongs_to :user

  validates :user, presence: true
  validates :setting_key, presence: true
end
