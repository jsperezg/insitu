# frozen_string_literal: true

json.array!(@payment_methods) do |payment_method|
  json.cache! payment_method do
    json.extract! payment_method, :id, :name, :note_for_invoice, :default
  end
end
