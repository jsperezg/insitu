# frozen_string_literal: true

json.cache! @invoice_status do
  json.partial! 'invoice_status', invoice_status: @invoice_status
end
