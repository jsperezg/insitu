# frozen_string_literal: true

module CustomersHelper
  def customer_field(form, method, options = {})
    options[:class] = "form-group customer-selector #{options[:class]}".strip
    options[:input_class] = "form-control input-sm #{options[:input_class]}".strip
    hidden_class = options[:filterrific] ? 'filterrific-periodically-observed' : ''

    content = [
      customer_label_tag(form, method, options),
      customer_field_tag(form, method, options),
      form.hidden_field(method, class: hidden_class)
    ]

    content_tag(:div, class: options[:class], url_source: api_v1_customers_path(format: :json)) do
      raw(content.join(''))
    end
  end

  def link_to_contact_email(customer)
    return if customer.contact_name.blank?
    return customer.contact_name if customer.contact_email.blank?

    link_to customer.contact_name, "mailto:#{customer.contact_email}"
  end

  def create_customer_tag
    content_tag(:div, class: 'input-group-btn') do
      button_tag t(:new),
                 class: 'btn btn-default btn-sm',
                 type: 'button',
                 data: { toggle: 'modal', target: '#create-customer-modal' }
    end
  end

  def customer_label_tag(form, method, options)
    if options.key? :label
      form.label(method, options[:label], class: 'control-label', for: "#{form.object_name}_#{method}_finder")
    else
      form.label(method, class: 'control-label', for: "#{form.object_name}_#{method}_finder")
    end
  end

  def find_customer_tag(form, method, options)
    value = customer_field_value(form)

    text_field_tag("#{form.object_name}_#{method}_finder",
                   value,
                   class: options[:input_class],
                   placeholder: I18n.t('customers.select_customer_placeholder'),
                   required: options[:required])
  end

  def customer_field_value(form)
    value = ''

    if !form.object.nil? && form.object.respond_to?(:customer)
      customer = form.object.send('customer')
      value = customer.send('name') unless customer.nil?
    end

    value
  end

  def customer_field_tag(form, method, options)
    create_customer_button = if options.key?(:create_customer_button)
                               options[:create_customer_button]
                             else
                               true
                             end

    return create_customer_button_tag(form, method, options) if create_customer_button

    find_customer_tag(form, method, options)
  end

  def create_customer_button_tag(form, method, options)
    content_tag(:div, class: 'input-group') do
      raw([find_customer_tag(form, method, options), create_customer_tag].join(''))
    end
  end
end
