class SettingKey < ActiveRecord::Base
	validates :name, presence: true, uniqueness: { case_sensitive: false }
	validates :data_type, presence: true, uniqueness: { case_sensitive: false }

	enum data_type: [:integer, :string, :boolean, :date_time]
end
