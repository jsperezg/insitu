# frozen_string_literal: true

module SequenceGenerator
  extend ActiveSupport::Concern
  include Settings
  include HasDocumentNumber

  included do
    def generate_id(model_name, year, prefix_length = 1)
      serie_value = serie_for(model_name, prefix_length).value_s
      sequence_value = sequence_for(model_name, year).value_i

      "#{serie_value}/#{year}/#{sequence_value.to_s.rjust(6, '0')}"
    end

    def last_id(model_name, year, prefix_length = 1)
      serie_value = serie_for(model_name, prefix_length).value_s
      sequence_value = sequence_for(model_name, year).value_i
      sequence_value -= 1 if sequence_value > 1

      "#{serie_value}/#{year}/#{sequence_value.to_s.rjust(6, '0')}"
    end

    # Automatically manages series and sequences for document Id.
    def increase_id
      # Update the sequence.
      sequence_value = sequence_for(serie)
      return if sequence_value[:value_i] > number_parts[:sequence].to_i

      sequence_value[:value_i] = number_parts[:sequence].to_i + 1
      sequence_value.save!
    end

    def decrease_id
      sequence_value = sequence_for(serie)
      return if sequence_value.value_i <= 1

      sequence_value.value_i -= 1
      sequence_value.save!
    end
  end

  def serie_for(model_name, prefix_length = 1)
    key = find_or_create_key("#{model_name}.serie", SettingKey.data_types[:string])
    find_or_create_value(key, model_name[0..prefix_length].upcase)
  end

  def sequence_for(model_name, year = date.year)
    key = find_or_create_key("#{model_name}.#{year}", SettingKey.data_types[:integer])
    find_or_create_value(key, 1)
  end

  def serie
    return number_parts[:serie] if try(:amending_invoice?)
    return customer.billing_serie.capitalize if custom_billing_serie?

    result = model_name.human
    update_serie_for_model_name(result, number_parts[:serie])
    result
  end

  def update_serie_for_model_name(model_name, serie)
    serie_value = serie_for(model_name, serie.length)
    serie_value.update!(value_s: serie) if serie_value[:value_s] != serie
  end

  def custom_billing_serie?
    customer&.billing_serie.present? && is_a?(Invoice)
  end
end
