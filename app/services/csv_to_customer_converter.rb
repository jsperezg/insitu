require 'csv'
class CsvToCustomerConverter < CsvToModelConverter
  def initialize
    @model = Customer
    @attributes = %i(tax_id name contact_name contact_phone contact_email address city country postal_code state send_invoices_to)
  end

  def import_options
    {
      value_converters: {
        @model.human_attribute_name(:country) => CountryConverter
      }
    }
  end
end