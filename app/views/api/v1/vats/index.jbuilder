# frozen_string_literal: true

json.vats @vats.each do |vat|
  json.cache! vat do
    json.partial! 'vat', vat: vat
  end
end
