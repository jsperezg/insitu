module ApplicationHelper
	def has_role?(role_name)
		if role_name.split('|').include? current_user.role.try(:description)
	  		yield
		end
	end

  	def form_group(attribute, model, css_class = nil)
  		css_class = css_class || []
  		css_class << 'form-group'

  		if model.errors.key? model
  			css_class << 'has_error'
		end

  		content_tag(:div, class: css_class) do
  			yield
  		end	
	end
end
