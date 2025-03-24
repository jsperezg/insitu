# frozen_string_literal: true

module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    content_tag :div, class: 'alert alert-error alert-block' do
      content_tag(:button, 'x', class: 'close', 'data-dismiss' => 'alert') +
        content_tag(:h4, localized_devise_error_title) +
        content_tag(:ul, resource_error_messages)
    end
  end

  private

  def resource_error_messages
    resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
  end

  def localized_devise_error_title
    I18n.t('errors.messages.not_saved',
           count: resource.errors.count,
           resource: resource.class.model_name.human.downcase)
  end
end
