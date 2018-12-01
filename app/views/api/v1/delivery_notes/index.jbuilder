# frozen_string_literal: true

json.delivery_notes @delivery_notes.each do |delivery_note|
  json.partial! 'delivery_note', delivery_note: delivery_note
end
