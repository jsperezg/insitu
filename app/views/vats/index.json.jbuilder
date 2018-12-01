# frozen_string_literal: true

json.array!(@vats) do |vat|
  json.cache! vat do
    json.extract! vat, :id, :label, :rate, :default
  end
end
