# frozen_string_literal: true

module Settings
  def find_or_create_key(name, data_type)
    key = SettingKey.find_by(name: name)
    key = SettingKey.create!(name: name, data_type: data_type) if key.nil?
    key
  end

  def find_or_create_value(key, default)
    value = SettingValue.find_by(setting_key: key.id)
    if value.nil? && !default.nil?
      value = case key[:data_type]
              when 'string'
                SettingValue.create(setting_key_id: key.id, value_s: default)

              when 'integer'
                SettingValue.create(setting_key_id: key.id, value_i: default)

              when 'boolean'
                SettingValue.create(setting_key_id: key.id, value_b: default)

              when 'date_time'
                SettingValue.create(setting_key_id: key.id, value_d: default)

              else
                SettingValue.create(setting_key_id: key.id, value_s: default.to_s)
              end
    end

    value
  end

  def init_default_settings
    year = Date.today.year

    [DeliveryNote.model_name, Invoice.model_name, Estimate.model_name].each do |model|
      key = find_or_create_key("#{model}.serie", SettingKey.data_types[:string])
      find_or_create_value(key, model.singular.capitalize[0])

      key = find_or_create_key("#{model}.#{year}", SettingKey.data_types[:integer])
      find_or_create_value(key, 1)
    end
  end
end
