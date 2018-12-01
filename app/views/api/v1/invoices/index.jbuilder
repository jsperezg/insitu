# frozen_string_literal: true

json.invoices @invoices.each do |invoice|
  json.partial! 'invoice', invoice: invoice
end
