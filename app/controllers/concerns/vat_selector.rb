# frozen_string_literal: true

# Adds helper method that generates options for select from vats table.
module VatSelector
  extend ActiveSupport::Concern

  included do
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::NumberHelper
    include VatsHelper

    helper_method :vat_options_for_select

    def vat_options_for_select(key = :id, selected = nil)
      selected_value = selected.try(key) || Vat.default.try(key)
      options_for_select(Vat.order(rate: :asc).map { |vat| [vat_label_for(vat), vat[key]] }, selected_value)
    end
  end
end