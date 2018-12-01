# frozen_string_literal: true

json.cache! @unit do
  json.extract! @unit, :id, :label_short, :label_long
end
