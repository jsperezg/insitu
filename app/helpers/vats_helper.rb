# frozen_string_literal: true

# Helper methods used with vat related views
module VatsHelper
  def vat_label_for(vat)
    number_to_percentage(vat.rate, precision: 0)
  end
end
