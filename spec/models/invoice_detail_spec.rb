# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceDetail, type: :model do
  before(:each) do
    Thread.current[:user] = create(:user)
  end

  describe 'quantity' do
    it 'is mandatory' do
      invoice_detail = InvoiceDetail.new
      invoice_detail.save

      expect(invoice_detail.errors).to have_key  :quantity
    end

    it 'must be a number' do
      invoice_detail = InvoiceDetail.new(quantity: 'asdf')
      invoice_detail.save

      expect(invoice_detail.errors).to have_key  :quantity
    end

    it 'is greater than zero' do
      invoice_detail = InvoiceDetail.new(quantity: 0)
      invoice_detail.save

      expect(invoice_detail.errors).to have_key :quantity
    end
  end

  describe 'price' do
    it 'is mandatory' do
      invoice_detail = InvoiceDetail.new
      invoice_detail.save

      expect(invoice_detail.errors).to have_key :price
    end

    it 'must be a number' do
      invoice_detail = InvoiceDetail.new(price: 'asdf')
      invoice_detail.save

      expect(invoice_detail.errors).to have_key :price
    end

    it 'is greater than zero' do
      invoice_detail = InvoiceDetail.new(price: -1)
      invoice_detail.save

      expect(invoice_detail.errors).to have_key :price
    end
  end

  describe 'vat rate' do
    it 'is mandatory' do
      invoice_detail = InvoiceDetail.new
      invoice_detail.save

      expect(invoice_detail.errors).to have_key :vat_rate
    end

    it 'must be a number' do
      invoice_detail = InvoiceDetail.new(vat_rate: 'asdf')
      invoice_detail.save

      expect(invoice_detail.errors).to have_key :vat_rate
    end

    it 'is greater or equal to zero' do
      invoice_detail = InvoiceDetail.new(vat_rate: -1)
      invoice_detail.save

      expect(invoice_detail.errors).to have_key :vat_rate
    end

    it 'is a integer number' do
      invoice_detail = InvoiceDetail.new(vat_rate: 1.1)
      invoice_detail.save

      expect(invoice_detail.errors).to have_key :vat_rate
    end
  end

  describe 'discount' do
    it 'is zero by default' do
      invoice_detail = InvoiceDetail.new
      invoice_detail.save

      expect(invoice_detail.discount).to equal(0)
    end

    it 'must be a number' do
      invoice_detail = InvoiceDetail.new(discount: 'asdf')
      invoice_detail.save

      expect(invoice_detail.errors).to have_key :discount
    end

    it 'is greater or equal to zero' do
      invoice_detail = InvoiceDetail.new(discount: -1)
      invoice_detail.save

      expect(invoice_detail.errors).to have_key :discount
    end
  end

  describe 'totals' do
    it 'total includes discount, vat, price and quantity' do
      r = InvoiceDetail.new(quantity: 1.0, price: 100.0, vat_rate: 21.0, discount: 10.0)
      expect(r.total).to eq(108.9)
    end
  end

  describe 'removing invoice details' do
    let(:invoice_detail) { create(:invoice_detail) }

    it 'leaves time log record pending for invoice' do
      time_log = create(:time_log, invoice_detail_id: invoice_detail.id)

      invoice_detail.destroy

      time_log.reload
      expect(time_log.invoice_detail_id).to be_nil
    end

    it 'leaves estimate record pending for invoice' do
      estimate_detail = create(:estimate_detail, invoice_detail_id: invoice_detail.id)

      invoice_detail.destroy

      estimate_detail.reload
      expect(estimate_detail.invoice_detail_id).to be_nil
    end

    it 'leaves delivery note record pending for invoice' do
      delivery_note_detail = create(:delivery_note_detail, invoice_detail_id: invoice_detail.id)

      invoice_detail.destroy

      delivery_note_detail.reload
      expect(delivery_note_detail.invoice_detail_id).to be_nil
    end
  end
end
