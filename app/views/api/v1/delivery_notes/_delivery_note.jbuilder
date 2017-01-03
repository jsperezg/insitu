json.cache! delivery_note do
  json.extract! delivery_note, :id, :number, :customer_id, :date
  json.delivery_note_details delivery_note.delivery_note_details do |detail|
    json.cache! detail do
      json.extract! detail, :id, :service_id, :custom_description, :quantity, :price, :invoice_detail_id, :total
    end
  end
end