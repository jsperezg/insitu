# frozen_string_literal: true

class RenewSubscriptionJob < ApplicationJob
  include InvoicingNotifications

  queue_as :urgent

  rescue_from(Exception) do |e|
    Rails.logger.error e
    retry_job wait: 8.hours, queue: :default
  end

  def perform(*payment_id)
    payment = Payment.find_by(id: payment_id)
    send_invoice(payment) unless payment.nil?
  end

  def send_invoice(payment)
    billing_account = User.find_by(email: ENV['PAYPAL_RECEIVER_EMAIL'])
    begin
      Apartment::Tenant.switch! billing_account.try(:tenant) unless Rails.env.test?
      invoice = generate_invoice(payment)
      send_invoice_by_email(billing_account, invoice)
    rescue StandardError => e
      raise e
    ensure
      Apartment::Tenant.switch! unless Rails.env.test?
    end
  end

  def generate_invoice(payment)
    invoice = invoice_header_for(payment)

    InvoiceDetail.create!(
      invoice_id: invoice.id,
      service_id: find_or_create_service(payment.plan).id,
      description: "Renovación #{payment.plan.months} meses/#{payment.plan.months} months renewal",
      vat_rate: payment.plan.vat_rate,
      price: payment.plan.price,
      quantity: 1
    )

    invoice
  end

  def invoice_header_for(payment)
    Invoice.create!(
      date: payment.payment_date,
      payment_method_id: find_or_create_payment_method('Paypal').try(:id),
      customer_id: find_or_create_customer(payment.user).try(:id),
      invoice_status_id: InvoiceStatus.paid&.id,
      payment_date: payment.payment_date,
      paid_on: payment.payment_date
    )
  end

  def find_or_create_payment_method(method_name)
    payment_method = PaymentMethod.find_by(name: method_name)
    payment_method = PaymentMethod.create!(name: method_name) if payment_method.nil?

    payment_method
  end

  def find_or_create_customer(user)
    customer = Customer.find_by(tax_id: user.tax_id, country: user.country)
    if customer.nil?
      customer = create_customer_for(user)
    else
      update_customer(customer, user)
    end

    customer
  end

  def create_customer_for(user)
    Customer.create!(
      tax_id: user.tax_id,
      country: user.country,
      name: user.name,
      address: user.address,
      city: user.city,
      postal_code: user.postal_code,
      state: user.state,
      contact_email: user.email,
      contact_phone: user.phone_number,
      irpf: 0
    )
  end

  def update_customer(customer, user)
    customer.update_attributes!(
      name: user.name,
      address: user.address,
      city: user.city,
      postal_code: user.postal_code,
      state: user.state,
      contact_email: user.email,
      contact_phone: user.phone_number
    )
  end

  def find_or_create_service(plan)
    service = Service.find_by(description: plan.description, active: true)
    return service if service.present?

    create_service(plan)
  end

  def create_service(plan)
    Service.create!(
      code: "S/#{Time.now.strftime('%Y%m%d')}/#{plan.months}",
      description: plan.description,
      vat_id: find_or_create_vat(plan.vat_rate).id,
      unit_id: find_or_create_unit('Months').id,
      price: plan.price
    )
  end

  def find_or_create_vat(vat_rate)
    vat = Vat.find_by(rate: vat_rate)
    if vat.nil?
      vat = Vat.create!(
        rate: vat_rate,
        default: false
      )
    end

    vat
  end

  def find_or_create_unit(label)
    unit = Unit.find_by(label_long: label)
    if unit.nil?
      unit = Unit.create!(
        label_long: label,
        label_short: label[0, 1].upcase
      )
    end

    unit
  end
end
