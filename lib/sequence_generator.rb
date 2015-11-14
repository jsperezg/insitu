module SequenceGenerator
	include Settings

	def generate_id(user, model_name, year)
		# Get serie.
		key = find_or_create_key("#{ model_name }.serie", SettingKey.data_types[:string])
		serie_value = find_or_create_value(user, key, model_name[0].capitalize)
		
		# Get value
		key = find_or_create_key("#{ model_name }.#{ year }", SettingKey.data_types[:integer])
		sequence_value = find_or_create_value(user, key, 1)
		
		"#{ serie_value[:value_s] }/#{ year }/" + sequence_value[:value_i].to_s.rjust(6, '0')
	end

	def increase_id(user, model_name, year)		
		key = SettingKey.find_by(name: "#{ model_name }.#{ year }")
		unless key.nil?
			value = SettingValue.find_by(user_id: user.id, setting_key_id: key.id)
			value[:value_i] += 1
			value.save
		end
	end
end