module ApplicationHelper
	def has_role?(role_name)
		if role_name.split('|').include? current_user.role.try(:description)
	  		yield
		end
	end

	def ldate object, options = {}
		object.present? ? localize(object, options) : ''
	end
end
