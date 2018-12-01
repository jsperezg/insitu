# frozen_string_literal: true

module PlansHelper
  require 'open-uri'

  def payment_buttons_tag
    return if current_user.premium?

    plans = Plan.where(is_active: true).order(months: :asc)

    content_tag :div, class: :row do
      buttons = []

      plans.each do |plan|
        buttons << content_tag(:div, class: 'col-xs-4') do
          form_tag("#{paypal_base_url}/cgi-bin/webscr", method: :post, authenticity_token: false, enforce_utf8: false, target: '_top') do
            content_tag(:div, class: 'panel panel-info') do
              panel_elements = []

              panel_elements << plan_header_tag(plan)

              panel_elements << content_tag(:div, class: 'panel-body') do
                elements = []
                elements << plan_price_tag(plan)
                elements << paypal_payment_tag(plan)

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

  def plan_header_tag(plan)
    content_tag(:div, class: 'panel-heading') do
      content_tag(:h3, plan_name(plan), class: 'panel-title text-center')
    end
  end

  def plan_price_tag(plan)
    plan_price = []

    plan_price << content_tag(:h4, number_to_currency(plan.price, precision: 2, unit: '€', format: '%n %u'), class: 'text-center')
    plan_price << content_tag(:h5, "(#{plan.vat_rate}% excl.)", class: 'text-center')

    plan_price.join('').html_safe
  end

  def paypal_payment_tag(plan)
    elements = []

    elements << hidden_field_tag('business', Rails.configuration.x.paypal_receiver_email)
    elements << hidden_field_tag('item_name', plan_name(plan))
    elements << hidden_field_tag('quantity', 1)
    elements << hidden_field_tag('undefined_ quantity', 0)
    elements << hidden_field_tag('button', 'buynow')
    elements << hidden_field_tag('amount', plan.price)
    elements << hidden_field_tag('currency_code', 'EUR')
    elements << hidden_field_tag('shipping', '0.0')
    elements << hidden_field_tag('tax', plan.price * plan.vat_rate / 100.0)
    elements << hidden_field_tag('tax_rate', plan.vat_rate)
    elements << hidden_field_tag('notify_url', calculate_ipn_listener_url)
    elements << hidden_field_tag('env', 'www.sandbox')
    elements << hidden_field_tag('cmd', '_xclick')
    elements << hidden_field_tag('item_number', plan.id)
    elements << hidden_field_tag('tax_rate', plan.vat_rate)
    elements << hidden_field_tag('custom', current_user.id)
    elements << hidden_field_tag('no_shipping', '1')
    elements << hidden_field_tag('return_url', renew_sent_user_url(current_user))
    elements << hidden_field_tag('cancel_url', renew_user_url(current_user))
    elements << image_submit_tag('https://www.paypalobjects.com/webstatic/en_US/btn/btn_buynow_cc_171x47.png',
                                 border: 0,
                                 name: 'submit',
                                 alt: 'PayPal. La forma rápida y segura de pagar en Internet.',
                                 class: 'center-block')
    elements.join('').html_safe
  end

  def plan_name(plan)
    if plan.months == 1
      I18n.t('plans.renew_label_1_month')
    else
      I18n.t('plans.renew_label_n_month', months: plan.months)
    end
  end

  def paypal_base_url
    if Rails.env.development?
      'https://www.sandbox.paypal.com'
    else
      'https://www.paypal.com'
    end
  end

  def calculate_ipn_listener_url
    if Rails.env.development?
      remote_ip = open('http://whatismyip.akamai.com').read
      "http://#{remote_ip}#{ipn_listener_index_path}"
    else
      ipn_listener_index_url
    end
  end
end
