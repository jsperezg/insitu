class CSVExport
  def initialize(attributes)
    @attributes = attributes
  end

  def run(data)
    CSV.generate do |csv|
      csv << @attributes
      data.each do |record|
        csv << data_row(record)
      end
    end
  end

  private

  def data_row(record)
    result = []

    @attributes.each do |attribute|
      result << record.try(attribute)
    end

    result
  end
end