# frozen_string_literal: true

module Settings
  TYPE_MAPPING = {
    string: :value_s,
    integer: :value_i,
    boolean: :value_b,
    date_time: :value_d
  }.with_indifferent_access.freeze.freeze

  def find_or_create_key(name, data_type)
    SettingKey.find_or_initialize_by(name: name) do |key|
      key.data_type = data_type
      key.save!
    end
  end

  def find_or_create_value(key, default)
    value = SettingValue.find_by(setting_key: key.id)
    return value if value.present? || default.nil?

    value_attribute = TYPE_MAPPING[key.data_type] || :value_s
    SettingValue.create!(setting_key_id: key.id, value_attribute => default.to_s)
  end

  def init_default_settings
    year = Date.today.year

    [DeliveryNote.model_name, Invoice.model_name, Estimate.model_name].each do |model|
      initialize_key(model)
      initialize_value(model, year)
    end
  end

  private

  def initialize_value(model, year)
    key = find_or_create_key("#{model}.#{year}", SettingKey.data_types[:integer])
    find_or_create_value(key, 1)
  end

  def initialize_key(model)
    key = find_or_create_key("#{model}.serie", SettingKey.data_types[:string])
    find_or_create_value(key, model.singular.capitalize[0])
  end
end
