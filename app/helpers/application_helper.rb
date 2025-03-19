# frozen_string_literal: true

module ApplicationHelper
  def role?(role_name, &block)
    capture(&block) if role_name.split('|').include? current_user.role.try(:description)
  end

  def ldate(object, options = {})
    object.present? ? localize(object, options) : ''
  end

  # Helper that generates the navigation breadcrumb for each page.
  def content_header
    tag_content = [content_title, breadcrumb_content].compact

    content_tag(:section, class: 'content-header') do
      raw(tag_content.join(''))
    end
  end

  def content_title
    content_tag(:h1) do
      I18n.t(NAVIGATION_RULES[controller_name.to_sym][action_name.to_sym][:title])
    end
  end

  def active_element
    content_tag(:li, class: 'active') do
      I18n.t(NAVIGATION_RULES[controller_name.to_sym][action_name.to_sym][:title])
    end
  end

  # This method generates a hash with all required elements for a navigation bar's link.
  def link_details(parent_key)
    return '#' unless parent_key.is_a? Hash

    link_parameters = {
      controller: parent_key[:controller],
      action: parent_key[:action]
    }

    parent_key[:params]&.each do |param_key|
      link_parameters[param_key] = params[param_key]
    end

    link_parameters
  end

  def input_code(form, options = nil)
    options ||= {}

    options[:class] = 'form-control input-sm document-id' unless options.key? :class
    options[:class] = "#{options[:class]} document-id" unless options[:class].include? 'document-id'

    form.text_field :number, class: options[:class], required: true, autofocus: true, style: 'text-transform:uppercase'
  end

  def premium_wrapper_tag(&block)
    content_class = current_user.premium? ? '' : 'control-sidebar-open'
    content = capture(&block)

    content_tag :div, content, class: content_class
  end

  def previous_url
    session[:previous_url] || user_dashboard_index_url(current_user.id)
  end

  private

  def breadcrumb_content
    controller_name_sym = controller_name.to_sym
    action_name_sym = action_name.to_sym
    return unless NAVIGATION_RULES[controller_name_sym][action_name_sym].key? :parent

    content_tag(:ol, class: 'breadcrumb') do
      raw(nav_content)
    end
  end

  def nav_content
    result = [active_element]

    # Iterate over parents
    parent_key = NAVIGATION_RULES[controller_name.to_sym][action_name.to_sym][:parent]
    element = element_for(parent_key)

    while element.present?
      result << parent_link(element, parent_key)

      parent_key = element[:parent]
      element = element_for(parent_key)
    end

    result.reverse.join('')
  end

  def parent_link(element, parent_key)
    current_content = []

    content_tag(:li) do
      link_to(link_details(parent_key)) do
        current_content << content_tag(:i, nil, class: element[:icon]) unless element[:icon].blank?

        current_content << I18n.t(element[:title])

        raw(current_content.join(''))
      end
    end
  end

  def element_for(key)
    case key
    when Symbol
      NAVIGATION_RULES[key]
    when Hash
      NAVIGATION_RULES[key[:controller]][key[:action]]
    end
  end
end
