# frozen_string_literal: true

require 'rails_helper'

describe InvoiceCorrector do
  describe 'Invoice cancellation' do
    let(:invoice) { create(:invoice) }
    let(:service) { described_class.new(invoice) }
    let(:amending_invoice) { service.cancel }

    before do
      create(:invoice_detail, invoice_id: invoice.id)
    end

    it 'Creates an amending invoice' do
      expect(amending_invoice).not_to be_nil
    end

    it 'amending invoices is accessible from invoice object' do
      amending_invoice = service.cancel
      invoice.reload
      expect(invoice.amending_invoices).not_to be_empty
      expect(invoice.amending_invoices.first.id).to eq(amending_invoice.id)
    end

    it 'Amended invoice is accessible from invoice object' do
      expect(amending_invoice.amended_invoice&.id).to eq(invoice.id)
    end

    it 'Amended invoice cancels original invoice' do
      expect(amending_invoice.total).to be < 0
      expect(amending_invoice.total).to eq(invoice.total * -1)
    end

    it 'Amended invoices use a different series' do
      idx = amending_invoice.number.index('/')
      expect(amending_invoice.number[0..idx]).not_to eq(invoice.number[0..idx])
    end

    it 'Canceling an invoice do not overrides original invoice series' do
      invoice2 = create(:invoice)
      idx = invoice2.number.index('/')
      expect(invoice2.number[0..idx]).to eq(invoice.number[0..idx])
    end
  end
end
