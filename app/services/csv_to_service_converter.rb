require 'csv'
class CsvToServiceConverter < CsvToModelConverter
  def initialize
    @model = Service
    @attributes = %i(code description vat_id unit_id price)
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