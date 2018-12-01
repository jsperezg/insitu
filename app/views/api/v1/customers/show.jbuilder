# frozen_string_literal: true

json.cache! @customer do
  json.partial! 'customer', customer: @customer
end
