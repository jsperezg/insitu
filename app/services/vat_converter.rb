class VatConverter
  def self.convert(value)
    Vat.find_by(rate: value)&.id || Vat.create(label: "#{value} %", rate: value).id
  end
end