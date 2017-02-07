require 'smarter_csv'

class CSVImportService
  def initialize(converter)
    @converter = converter
  end

  def import(filename)
    errors = []
    File.open(filename,'r:bom|utf-8') do |f|
      rows = SmarterCSV.process(f, { keep_original_headers: true }.merge(@converter.import_options))
      row_number = 1
      rows.each do |row|
        errors += process_errors(@converter.create(row), row_number)
        row_number += 1
      end
    end

    errors
  end
  
  private
  
  def process_errors(errors, row_number)
    errors.each_with_index do |error,index|
      errors[index] = "[#{ row_number }] #{error}"
    end
  end
end