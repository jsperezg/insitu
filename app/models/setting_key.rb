class SettingKey < ActiveRecord::Base
	include ApartmentCacheKeyGenerator

	validates :name, presence: true, uniqueness: { case_sensitive: false }
	validates :data_type, presence: true

	enum data_type: [:integer, :string, :boolean, :date_time]
end
