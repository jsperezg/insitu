# frozen_string_literal: true

class SettingValue < ApplicationRecord
  belongs_to :setting_key

  validates :setting_key, presence: true
end
