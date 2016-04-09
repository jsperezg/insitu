module VatsHelper
  def bip_vats_collection
    Vat.order(rate: :asc).all.map { |v| [v.id, v.label ]}
  end
end
