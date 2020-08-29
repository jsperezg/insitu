# frozen_string_literal: true

json.array!(@units) do |unit|
  json.cache! unit do
    json.extract! unit, :id, :label_short, :label_long
  end
end
