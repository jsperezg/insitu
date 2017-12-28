# frozen_string_literal

# Helper methods used with vat related views
module VatsHelper
  def bip_vats_collection
    Vat.order(rate: :asc).all.map { |v| [v.id, vat_label_for(v)] }
  end

  def vat_label_for(vat)
    number_to_percentage(vat.rate, precision: 0)
  end
end
