require 'smarter_csv'

class CSVImportService
  def initialize(converter)
    @converter = converter
  end

  def import(filename)
    File.open(filename,'r:bom|utf-8') do |f|
      rows = SmarterCSV.process(f, { keep_original_headers: true }.merge(@converter.import_options))
      rows.each do |row|
        @converter.create(row)
      end
    end
  end
end