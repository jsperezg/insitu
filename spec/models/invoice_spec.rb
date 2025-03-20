# frozen_string_literal: true

require 'rails_helper'

describe Invoice, type: :model do
  before do
    create(:payment_method, :default)
    Thread.current[:user] = User.first || create(:user)
  end

  describe 'Validations' do
    it 'date is mandatory' do
      invoice = described_class.new
      invoice.save

      expect(invoice.errors).to have_key(:date)
    end

    it 'customer is mandatory' do
      invoice = described_class.new
      invoice.save

      expect(invoice.errors).to have_key(:customer_id)
    end

    it 'payment date is mandatory' do
      invoice = described_class.new
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
      expect(invoice.number).to start_with(described_class.model_name.human[0].capitalize)
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
      invoice = build(:invoice, number: "I/#{Date.current.year}/000001")
      invoice.save

      expect(invoice.errors).to be_empty

      another_invoice = build(:invoice, number: "I/#{Date.current.year}/000001")
      another_invoice.save

      expect(another_invoice.errors).to have_key(:number)
    end

    it 'update default series for invoices' do
      customer = create(:customer, billing_serie: nil)

      invoice = build(:invoice, number: "X/#{Date.current.year}/000001", customer_id: customer.id)
      invoice.save

      expect(invoice.errors).to be_empty

      another_invoice = create(:invoice, customer_id: customer.id)
      another_invoice.reload

      expect(another_invoice.number).to eq("X/#{Date.current.year}/000002")
    end

    it 'Sequence is updated after updating invoices' do
      invoice = create(:invoice, number: "A/#{Date.current.year}/000002")
      expect(invoice.number).to end_with('000002')

      invoice.number = "A/#{Date.current.year}/000001"
      expect(invoice.save).to be_truthy

      other_invoice = create(:invoice)
      expect(other_invoice.number).to end_with('000002')
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
      invoice = build(:invoice, number: "i/#{Date.current.year}/000001")
      invoice.save

      expect(invoice.errors).to have_key(:number)
    end

    it 'Same year as bill' do
      invoice = build(:invoice, number: "i/#{Date.current.year + 1}/000001")
      invoice.save

      expect(invoice.errors).to have_key(:number)
    end

    it '6 digits' do
      invoice = build(:invoice, number: "i/#{Date.current.year}/xxxxxx")
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
    let(:taxes_invoice) do
      customer = create(:customer, irpf: 15, country: 'ES')
      invoice = attributes_for(:invoice, customer_id: customer.id, irpf: 15)

      invoice.merge(invoice_details_attributes: [attributes_for(:invoice_detail, invoice_id: nil)])
    end

    let(:no_taxes_invoice) do
      invoice = attributes_for(:invoice, irpf: 0)

      invoice.merge(invoice_details_attributes: [attributes_for(:invoice_detail, invoice_id: nil)])
    end

    it 'irpf 15%' do
      invoice = described_class.create! taxes_invoice

      gross_total = 0
      invoice.invoice_details.each do |detail|
        gross_total += detail.subtotal - detail.discount
      end

      expect(gross_total).not_to eq(0)
      expect(invoice.applied_irpf).not_to eq(0)
      expect(invoice.applied_irpf).to eq(gross_total * invoice.irpf / 100)

      tax_total = 0
      invoice.tax.each_key do |key|
        tax_total += invoice.tax[key]
      end

      expect(invoice.total).to eq(invoice.subtotal - invoice.discount - invoice.applied_irpf + tax_total)
    end

    it 'irpf 0%' do
      invoice = described_class.create! no_taxes_invoice

      gross_total = 0
      invoice.invoice_details.each do |detail|
        gross_total += detail.subtotal - detail.discount
      end

      expect(gross_total).not_to eq(0)
      expect(invoice.applied_irpf).to eq(0)

      tax_total = 0
      invoice.tax.each_key do |key|
        tax_total += invoice.tax[key]
      end

      expect(invoice.total).to eq(invoice.subtotal - invoice.discount - invoice.applied_irpf + tax_total)
    end
  end

  describe 'default values' do
    it 'default payment method' do
      default_payment_method = create(:payment_method, default: true)

      invoice = described_class.new
      expect(invoice.payment_method_id).to eq(default_payment_method.id)
    end
  end

  describe 'Invoice deletion' do
    let(:invoice) { create(:invoice) }

    it 'Last invoice of serie can be deleted' do
      expect(invoice).to be_deletion_allowed
      expect { invoice.destroy }.to change(described_class, :count).by(-1)
    end

    it 'Deletion of any other invoice will result into an exception' do
      invoice = create(:invoice)
      create(:invoice)
      expect(invoice).not_to be_deletion_allowed
      expect { invoice.destroy }.to raise_error(I18n.t('activerecord.errors.models.invoice.deletion_is_not_allowed'))
    end
  end
end
