# frozen_string_literal: true

# Converts a vat rate from a csv into a new Vat record.
class VatConverter
  def self.convert(value)
    Vat.find_by(rate: value)&.id || Vat.create(rate: value).id
  end
end