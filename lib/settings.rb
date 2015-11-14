module Settings
	def find_or_create_key(name, data_type) 
		key = SettingKey.find_by(name: name)
		if key.nil?
			key = SettingKey.create(name: name, data_type: data_type)
		end
	end

	def find_or_create_value(user, key, default)		
		value = SettingValue.find_by(user: user.id, setting_key: key.id)		
		if value.nil? and !default.nil?
			case key[:data_type]
			when SettingKey.data_types[:string]
				value = SettingValue.create(user_id: user.id, setting_key_id: key.id, value_s: default)

			when SettingKey.data_types[:integer]
				value = SettingValue.create(user_id: user.id, setting_key_id: key.id, value_i: default)

			when SettingKey.data_types[:boolean]
				value = SettingValue.create(user_id: user.id, setting_key_id: key.id, value_b: default)

			when SettingKey.data_types[:date_time]
				value = SettingValue.create(user_id: user.id, setting_key_id: key.id, value_d: default)

			else
				value = SettingValue.create(user_id: user.id, setting_key_id: key.id, value_s: default.to_s)
			end
		end
	end
end