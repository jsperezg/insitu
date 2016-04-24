module PlansHelper
  def payment_buttons_tag
    if current_user.has_expired?
      plans = Plan.where(is_active: true).where.not(hosted_button_id: nil).order(months: :asc)

      content_tag :div, class: :row do
        buttons = []

        plans.each do |plan|
          buttons << content_tag(:div, class: 'col-xs-4') do
            form_tag("#{ paypal_base_url }/cgi-bin/webscr", method: :post, html: { target: '_top' }) do
              content_tag(:div, class: 'panel panel-info') do
                panel_elements = []

                panel_elements << plan_header_tag(plan)

                panel_elements << content_tag(:div, class: 'panel-body') do
                    elements = []
                    elements << plan_price_tag(plan)
                    elements  << paypal_payment_tag(plan)

                    elements.join('').html_safe
                end

                panel_elements.join('').html_safe
              end
            end
          end
        end

        buttons.join('').html_safe
      end
    end
  end

  def plan_header_tag(plan)
    if plan.months == 1
      label = I18n.t('plans.renew_label_1_month')
    else
      label = I18n.t('plans.renew_label_n_month', months: plan.months)
    end

    content_tag(:div, class: 'panel-heading') do
      content_tag(:h3, label, class: 'panel-title text-center')
    end
  end

  def plan_price_tag(plan)
    plan_price = []

    plan_price << content_tag(:h4, number_to_currency(plan.price, :precision => 2, unit: '€', format: '%n %u'), class: 'text-center')
    plan_price << content_tag(:h5, "(#{ plan.vat_rate }% excl.)", class: 'text-center')

    plan_price.join('').html_safe
  end

  def paypal_payment_tag(plan)
    elements = []

    elements << hidden_field_tag('cmd', value: '_s-xclick')
    elements << hidden_field_tag('hosted_button_id', value: plan.hosted_button_id)

    elements << image_submit_tag(paypal_button_image,
                                 {
                                     border: 0,
                                     name: 'submit',
                                     alt: 'PayPal. La forma rápida y segura de pagar en Internet.',
                                     class: 'center-block'
                                 })
    elements << image_tag("#{ paypal_base_url}/es_ES/i/scr/pixel.gif", width: 1, height: 1, border: 0)

    elements.join('').html_safe
  end

  def paypal_base_url
    'https://www.sandbox.paypal.com' if Rails.env.development?

    'https://www.paypal.com'
  end

  def paypal_button_image
    if current_user.locale == 'es'
      #TODO Get image  for real button
      'https://www.sandbox.paypal.com/es_ES/ES/i/btn/btn_buynowCC_LG.gif'
    else
      'https://www.paypalobjects.com/webstatic/en_US/btn/btn_buynow_cc_171x47.png'
    end
  end

end
