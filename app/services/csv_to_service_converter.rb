# frozen_string_literal: true

class CsvToServiceConverter < CsvToModelConverter
  def initialize
    super

    @model = Service
    @attributes = %i[code description vat_id unit_id price]
  end

  def import_options
    {
      value_converters: {
        @model.human_attribute_name(:vat_id) => VatConverter,
        @model.human_attribute_name(:unit_id) => UnitConverter
      }
    }
  end
end
