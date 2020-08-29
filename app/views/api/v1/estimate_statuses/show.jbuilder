# frozen_string_literal: true

json.cache! @estimate_status do
  json.partial! 'estimate_status', estimate_status: @estimate_status
end
