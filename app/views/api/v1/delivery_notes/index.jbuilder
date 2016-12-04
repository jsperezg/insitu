json.tasks @delivery_notes.each do |delivery_note|
  json.partial! 'delivery_note', delivery_note: delivery_note
end