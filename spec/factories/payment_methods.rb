FactoryBot.define do
  factory :payment_method do
    sequence :name do |n|
      "Payment method #{n}"
    end

    note_for_invoice 'Note  for invoice'
  end

end
