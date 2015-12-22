module ApplicationHelper
	def has_role?(role_name)
		if role_name.split('|').include? current_user.role.try(:description)
      yield
		end
	end

	def ldate object, options = {}
		object.present? ? localize(object, options) : ''
	end

	# Helper that generates the navigation breadcrumb for each page.
	def content_header
    controller_name_sym = controller_name.to_sym
    action_name_sym = action_name.to_sym
    tag_content = []
    nav_content = []
    current_content = []

    content_tag(:section, class: 'content-header') do
      tag_content << content_tag(:h1) do
        begin
          I18n.t(NAVIGATION_RULES[controller_name_sym][action_name_sym][:title])
        rescue => e
          Rails.logger.error e
          "#{controller_name}.#{action_name}"
        end
      end

      begin
        if NAVIGATION_RULES[controller_name_sym].key? :root
          tag_content << content_tag(:ol, class: 'breadcrumb') do
            begin
              nav_content << content_tag(:li) do
                link_to(user_dashboard_index_path(current_user)) do
                  content_tag(:i, nil, class: NAVIGATION_RULES[controller_name_sym][:root][:icon]) +
                  I18n.t(NAVIGATION_RULES[controller_name_sym][:root][:title])
                end
              end

              if NAVIGATION_RULES[controller_name_sym][action_name_sym].key? :parent
                parent = NAVIGATION_RULES[controller_name_sym][action_name_sym][:parent]

                nav_content << content_tag(:li) do
                  link_to(controller: controller_name, action: parent, user_id: current_user.id) do
                    I18n.t(NAVIGATION_RULES[controller_name_sym][parent.to_sym][:title])
                  end
                end
              end
            rescue => e
              Rails.logger.error e
            end

            nav_content << content_tag(:li, class: 'active') do
              begin
                current_content << I18n.t(NAVIGATION_RULES[controller_name_sym][action_name_sym][:title])

                raw(current_content.join(''))
              rescue => e
                Rails.logger.error e
                "#{controller_name}.#{action_name}"
              end
            end

            raw(nav_content.join(''))
          end
        end
      rescue => e
        Rails.logger.error e
      end

      raw(tag_content.join(''))
    end
	end
end
