json.invoices @invoices.each do |invoice|
  json.partial! 'invoice', invoice: invoice
end