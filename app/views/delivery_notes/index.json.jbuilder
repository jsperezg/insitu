json.array!(@delivery_notes) do |delivery_note|
  json.extract! delivery_note, :id, :number, :customer_id, :date
  json.url delivery_note_url(delivery_note, format: :json)
end
