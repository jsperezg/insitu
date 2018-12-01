# frozen_string_literal: true

json.cache! @vat do
  json.partial! 'vat', vat: @vat
end
