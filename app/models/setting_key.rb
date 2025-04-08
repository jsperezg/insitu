# frozen_string_literal: true

class SettingKey < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :data_type, presence: true

  enum :data_type, { integer: 0, string: 1, boolean: 2, date_time: 3 }
end
