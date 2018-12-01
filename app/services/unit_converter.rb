# frozen_string_literal: true

class UnitConverter
  def self.convert(value)
    Unit.find_by(label_short: value)&.id || Unit.create(label_short: value).id
  end
end
