# frozen_string_literal: true

class SettingKey < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :data_type, presence: true

  enum data_type: %i[integer string boolean date_time]
end
