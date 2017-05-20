class CsvToModelConverter
  def create(row)
    model_data = parse(row)
    model = @model.new(model_data)
    model.save

    model.errors.full_messages
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

    converters = import_options[:value_converters]

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