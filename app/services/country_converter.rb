# frozen_string_literal: true

class CountryConverter
  def self.convert(value)
    ISO3166::Country.find_country_by_name(value)&.alpha2
  end
end
