require 'rails_helper'

RSpec.describe RenewSubscriptionJob, type: :job do
  describe('Generates invoice') do
    before(:each) do
      InvoiceStatus.find_by(name: 'invoice_status.paid') || InvoiceStatus.create!(name: 'invoice_status.paid')
      @payment = create(:payment)
    end

    it 'Creates Paypal payment method' do
      RenewSubscriptionJob.perform_now @payment.id

      expect(PaymentMethod.find_by(name: 'Paypal')).not_to be_nil
    end

    it 'Registers the customer' do
      RenewSubscriptionJob.perform_now @payment.id

      customer = Customer.find_by(tax_id: @payment.user.tax_id, country: @payment.user.country)
      expect(customer).not_to be_nil
    end

    it 'Registers Months as measure unit' do
      RenewSubscriptionJob.perform_now @payment.id

      unit = Unit.find_by(label_long: 'Months')
      expect(unit).not_to be_nil
    end

    it 'Creates vat rate that fits the plan details' do
      RenewSubscriptionJob.perform_now @payment.id

      vat = Vat.find_by(rate: @payment.plan.vat_rate)
      expect(vat).not_to be_nil
    end

    it 'Creates a service that fits the plan details' do
      RenewSubscriptionJob.perform_now @payment.id

      service = Service.find_by(description: @payment.plan.description,
                          vat_id: Vat.find_by(rate: @payment.plan.vat_rate).try(:id),
                          unit_id: Unit.find_by(label_long: 'Months').try(:id),
                          price: @payment.plan.price)

      expect(service).not_to be_nil
    end

    it 'Generates a new invoice for the payment' do
      RenewSubscriptionJob.perform_now @payment.id

      customer = Customer.find_by(tax_id: @payment.user.tax_id, country: @payment.user.country)
      expect(customer).not_to be_nil

      invoice = Invoice.find_by(customer_id: customer.id)
      expect(invoice).not_to be_nil

      # Validate invoice attributes
      payment_date = @payment.payment_date.strftime('%Y-%m-%d')

      expect(invoice.date.strftime('%Y-%m-%d')).to eq(payment_date)
      expect(invoice.payment_method_id).to eq(PaymentMethod.find_by(name: 'Paypal').id)
      expect(invoice.invoice_status_id).to eq(InvoiceStatus.find_by(name: 'invoice_status.paid').try(:id))
      expect(invoice.payment_date.strftime('%Y-%m-%d')).to eq(payment_date)
      expect(invoice.paid_on.strftime('%Y-%m-%d')).to eq(payment_date)

      expect(invoice.invoice_details.count).to be(1)

      detail = invoice.invoice_details.first

      service = Service.find_by(description: @payment.plan.description,
                                vat_id: Vat.find_by(rate: @payment.plan.vat_rate).try(:id),
                                unit_id: Unit.find_by(label_long: 'Months').try(:id),
                                price: @payment.plan.price)

      expect(detail.service_id).to eq(service.id)
      expect(detail.description).to eq("Renovación #{ @payment.plan.months } meses/#{ @payment.plan.months } months renewal")
      expect(detail.vat_rate).to eq(@payment.plan.vat_rate)
      expect(detail.price).to eq(@payment.plan.price)
      expect(detail.quantity).to eq(1)
      expect(detail.discount).to eq(0)
    end
  end

  describe('Invoice is sent by email') do
    before(:each) do
      User.find_by(email: Rails.configuration.x.paypal_billing_account) || create(:user, email: Rails.configuration.x.paypal_billing_account)

      InvoiceStatus.find_by(name: 'invoice_status.paid') || InvoiceStatus.create!(name: 'invoice_status.paid')
      @payment = create(:payment)
    end

    it 'invoice is generated and sent by email' do
      expect(InvoiceMailer).to receive(:send_to_customer)
      RenewSubscriptionJob.perform_now @payment.id
    end
  end
end
