module CustomersHelper
  def customer_field(form, method, options)
    content = []

    create_customer_button = true
    create_customer_button = options[:create_customer_button] if options.key? :create_customer_button

    # class for input.
    if options.key? :class
      options[:class] = "form-group customer-selector #{ options[:class]} "
    else
      options[:class] = 'form-group customer-selector'
    end

    if options.key? :input_class
      options[:input_class] = "form-control input-sm #{ options[:input_class]}"
    else
      options[:input_class] = 'form-control input-sm'
    end

    hidden_class = ''
    hidden_class = 'filterrific-periodically-observed' if options[:filterrific]

    content_tag(:div, class: options[:class], url_source: user_customers_path(current_user, format: :json)) do
      content << customer_label_tag(form, method, options)

      if create_customer_button
        content << content_tag(:div, class: 'input-group') do
          button_group = []
          button_group << find_customer_tag(form, method, options)
          button_group << create_customer_tag
          raw(button_group.join(''))
        end
      else
        content << find_customer_tag(form, method, options)
      end

      content << form.hidden_field(method, class: hidden_class)
      raw(content.join(''))
    end
  end

  def create_customer_tag
    content_tag(:div, class: 'input-group-btn') do
      button_tag t(:new), class: 'btn btn-default btn-sm',
                 type: 'button',
                 data: {toggle: 'modal', target: '#create-customer-modal'}
    end
  end

  def customer_label_tag(form, method, options)
    if options.key? :label
      form.label(method, options[:label], class: 'control-label', for: "#{ form.object_name }_#{ method }_finder")
    else
      form.label(method, class: 'control-label', for: "#{ form.object_name }_#{ method }_finder")
    end
  end

  def find_customer_tag(form, method, options)
    value = customer_field_value(form)

    text_field_tag("#{ form.object_name }_#{ method }_finder",
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
end

