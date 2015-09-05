json.array!(@delivery_note_details) do |delivery_note_detail|
  json.extract! delivery_note_detail, :id, :delivery_note_id, :service_id, :quantity
  json.url delivery_note_detail_url(delivery_note_detail, format: :json)
end
