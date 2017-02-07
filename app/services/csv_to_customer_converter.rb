require 'csv'
class CsvToCustomerConverter
  def initialize
    @model = Customer
    @attributes = [
        :tax_id, :name, :contact_name, :contact_phone, :contact_email, :address, :city, :country, :postal_code, :state, :send_invoices_to
    ]
  end

  def import_options
    {
        value_converters: {
            @model.human_attribute_name(:country) => CountryConverter
        }
    }
  end

  def create(row)
    model_data = parse(row)
    customer = @model.new(model_data)
    customer.save

    customer.errors.full_messages
  end

  def template
    CSV.generate do |csv|
      csv << header_row
      csv << example_row
    end
  end

  private

  def parse(row)
    result = {}

    @attributes.each do |attribute|
      human_readable = @model.human_attribute_name(attribute)
      result[attribute] = row[human_readable] if row.key?(human_readable)
    end

    result
  end

  def header_row
    row = []
    @attributes.each do |attribute|
      row << @model.human_attribute_name(attribute)
    end

    row
  end

  def example_row
    row = []
    @attributes.each do |attribute|
      row << attribute.to_s
    end

    row
  end

end