# frozen_string_literal: true

json.units @units.each do |unit|
  json.cache! unit do
    json.partial! 'unit', unit: unit
  end
end
