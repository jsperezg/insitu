# frozen_string_literal: true

json.cache! @vat do
  json.extract! @vat, :id, :rate, :default
end
