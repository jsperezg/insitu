# frozen_string_literal: true

module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">x</button>
      <h4>#{localized_devise_error_title}</h4>
      <ul>
      #{resource_error_messages}
      </ul>
    </div>
    HTML

    html.html_safe
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
