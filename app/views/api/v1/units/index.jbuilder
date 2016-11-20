json.vats @units.each do |unit|
  json.cache! unit do
    json.partial! 'unit', unit: unit
  end
end