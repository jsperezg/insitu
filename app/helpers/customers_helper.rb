module CustomersHelper
  def customer_field(form, method, options)
    content = []

    # class for input.
    if options.key? :class
      options[:class] = "form-group customer-selector #{ options[:class]} "
    else
      options[:class] = 'form-group customer-selector'
    end

    # value for approximate search
    value = ''

    unless form.object.nil?
      customer = form.object.send('customer')
      value = customer.send('name') unless customer.nil?
    end

    content_tag(:div, class: options[:class], url_source: user_customers_path(current_user, format: :json)) do
      content << form.label(method, class: 'control-label', for: "#{ form.object_name }_#{ method }_finder")
      content << text_field_tag("#{ form.object_name }_#{ method }_finder",
                                value,
                                class: 'form-control input-sm',
                                placeholder: I18n.t('customers.select_customer_placeholder'),
                                required: options[:required])
      content << form.hidden_field(method)
      raw(content.join(''))
    end
  end
end

