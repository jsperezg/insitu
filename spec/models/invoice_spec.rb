require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before(:each) do
    Thread.current[:user] = User.first || create(:user)
  end

  describe 'Validations' do
    it 'date is mandatory' do
      invoice = Invoice.new
      invoice.save

      expect(invoice.errors).to have_key(:date)
    end

    it 'payment method is mandatory' do
      invoice = Invoice.new
      invoice.save

      expect(invoice.errors).to have_key(:payment_method_id)
    end

    it 'customer is mandatory' do
      invoice = Invoice.new
      invoice.save

      expect(invoice.errors).to have_key(:customer_id)
    end

    it 'payment date is mandatory' do
      invoice = Invoice.new
      invoice.save

      expect(invoice.errors).to have_key(:payment_date)
    end
  end

  describe 'Invoice series' do
    it 'generic series' do
      customer = create(:customer, billing_serie: nil)
      invoice = create(:invoice, customer_id: customer.id)

      invoice.reload

      expect(invoice.errors.empty?).to be(true)
      expect(invoice.number).to start_with(Invoice.model_name.human[0].capitalize)
    end

    it 'custom series' do
      customer = create(:customer, billing_serie: 'A')
      invoice = create(:invoice, customer_id: customer.id)

      invoice.reload

      expect(invoice.errors).to be_empty
      expect(invoice.number).to start_with('A')
      expect(invoice.number).to end_with('00001')

      another_invoice = create(:invoice, customer_id: customer.id)

      another_invoice.reload

      expect(another_invoice.errors).to be_empty
      expect(another_invoice.number).to start_with('A')
      expect(another_invoice.number).to end_with('00002')
    end

    it 'do not allow duplicates' do
      invoice = build(:invoice, number: "I/#{Date.today.year}/000001")
      invoice.save

      expect(invoice.errors).to be_empty

      another_invoice = build(:invoice, number: "I/#{Date.today.year}/000001")
      another_invoice.save

      expect(another_invoice.errors).to have_key(:number)
    end

    it 'update default series for invoices' do
      customer = create(:customer, billing_serie: nil)

      invoice = build(:invoice, number: "X/#{Date.today.year}/000001", customer_id: customer.id)
      invoice.save

      expect(invoice.errors).to be_empty

      another_invoice = create(:invoice, customer_id: customer.id)
      another_invoice.reload

      expect(another_invoice.number).to eq("X/#{Date.today.year}/000002")
    end

    it 'Sequence is updated after updating invoices' do
      customer = create(:customer, billing_serie: 'A')
      invoice = create(:invoice, customer_id: customer.id)
      expect(invoice.number).to end_with('000001')

      other_invoice = create(:invoice, customer_id: customer.id)
      expect(other_invoice.number).to end_with('000002')

      invoice.destroy

      other_invoice.number = invoice.number
      expect(other_invoice.save).to be_truthy

      invoice = create(:invoice, customer_id: customer.id)
      expect(invoice.number).to end_with('000002')
    end

    it 'Sequence is updated after removing last invoice' do
      customer = create(:customer, billing_serie: 'A')
      invoice = create(:invoice, customer_id: customer.id)
      expect(invoice.number).to end_with('000001')

      other_invoice = create(:invoice, customer_id: customer.id)
      expect(other_invoice.number).to end_with('000002')

      other_invoice.destroy

      other_invoice = create(:invoice, customer_id: customer.id)
      expect(other_invoice.number).to end_with('000002')
    end
  end

  describe 'Number format validation' do
    it 'First capital letter' do
      invoice = build(:invoice, number: "i/#{Date.today.year}/000001")
      invoice.save

      expect(invoice.errors).to have_key(:number)
    end

    it 'Same year as bill' do
      invoice = build(:invoice, number: "i/#{Date.today.year + 1}/000001")
      invoice.save

      expect(invoice.errors).to have_key(:number)
    end

    it '6 digits' do
      invoice = build(:invoice, number: "i/#{Date.today.year}/xxxxxx")
      invoice.save

      expect(invoice.errors).to have_key(:number)
    end
  end

  it 'valid invoices' do
    10.times do
      invoice = build(:invoice)
      invoice.save

      expect(invoice.errors.empty?).to be(true)
    end
  end

  describe 'billing process' do
    let(:irpf_15) {
      customer = create(:customer, irpf: 15, country: 'ES')
      invoice = attributes_for(:invoice, customer_id: customer.id, irpf: 15)

      invoice.merge(invoice_details_attributes: [attributes_for(:invoice_detail, invoice_id: nil)])
    }

    let(:irpf_0) {
      invoice = attributes_for(:invoice, irpf: 0)

      invoice.merge(invoice_details_attributes: [attributes_for(:invoice_detail, invoice_id: nil)])
    }

    it 'irpf 15%' do
      invoice = Invoice.create! irpf_15

      gross_total = 0
      invoice.invoice_details.each do |detail|
        gross_total += detail.subtotal - detail.discount
      end

      expect(gross_total).not_to eq(0)
      expect(invoice.applied_irpf).not_to eq(0)
      expect(invoice.applied_irpf).to eq(gross_total * invoice.irpf / 100)

      tax_total = 0
      invoice.tax.each do |key, value|
        tax_total += invoice.tax[key]
      end

      expect(invoice.total).to eq(invoice.subtotal - invoice.discount - invoice.applied_irpf + tax_total)
    end

    it 'irpf 0%' do
      invoice = Invoice.create! irpf_0

      gross_total = 0
      invoice.invoice_details.each do |detail|
        gross_total += detail.subtotal - detail.discount
      end

      expect(gross_total).not_to eq(0)
      expect(invoice.applied_irpf).to eq(0)

      tax_total = 0
      invoice.tax.each do |key, value|
        tax_total += invoice.tax[key]
      end

      expect(invoice.total).to eq(invoice.subtotal - invoice.discount - invoice.applied_irpf + tax_total)
    end
  end

  describe 'default values' do
    it 'default payment method' do
      default_payment_method = create(:payment_method, default: true)

      invoice = Invoice.new
      expect(invoice.payment_method_id).to eq(default_payment_method.id)
    end
  end
end
