module SequenceGenerator
	include Settings

	def generate_id(model_name, year)
		# Get serie.
		key = find_or_create_key("#{ model_name }.serie", SettingKey.data_types[:string])
		serie_value = find_or_create_value(key, model_name[0].capitalize)
		
		# Get value
		key = find_or_create_key("#{ model_name }.#{ year }", SettingKey.data_types[:integer])
		sequence_value = find_or_create_value(key, 1)
		
		"#{ serie_value[:value_s] }/#{ year }/" + sequence_value[:value_i].to_s.rjust(6, '0')
	end

  # Automatically manages series and sequences for document Id.
	def increase_id entity
    year = entity.date.year
    number_parts = parse_number entity.number

    if entity.customer.try(:billing_serie).blank? or (!entity.is_a? Invoice)
      model_name = self.model_name.human

      # Update the serie
      key = find_or_create_key("#{ model_name }.serie", SettingKey.data_types[:string])
      serie_value = find_or_create_value(key, model_name[0].capitalize)

      if serie_value[:value_s] != number_parts[:serie]
        serie_value[:value_s] = number_parts[:serie]
        serie_value.save!
      end
    else
      model_name = entity.customer.billing_serie.capitalize
    end

    # Update the sequence.
    key = find_or_create_key("#{ model_name }.#{ year }", SettingKey.data_types[:integer])
    sequence_value = find_or_create_value(key, 1)

    if sequence_value[:value_i] == number_parts[:sequence].to_i
      sequence_value[:value_i] += 1
      sequence_value.save!
    end

    if sequence_value[:value_i] < number_parts[:sequence].to_i
      sequence_value[:value_i] = number_parts[:sequence].to_i + 1
      sequence_value.save!
    end
	end

  def is_number_valid? value, date
    return false if value.blank?

		parts = parse_number value

		return false if parts.nil?
		return false if !date.nil? and date.year != parts[:year]

		true
  end

  def parse_number value
    result = nil

    unless value.blank?
      parts = value.match(/^([A-Z]+)\/(\d{4})\/(\d{6})$/)

      if parts
        result = {
            serie: parts.captures[0],
            year: parts.captures[1].to_i,
            sequence: parts.captures[2].to_i
        }
      end
    end

    result
  end
end