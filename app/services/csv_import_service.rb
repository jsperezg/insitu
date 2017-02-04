require 'csv'

class CSVImportService
  def initialize(model, attributes)
    @model = model
    @attributes = attributes
  end

  def template
    csv_string = CSV.generate do |csv|
      csv << header_row
      csv << example_row
    end

    csv_string
  end

  private

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