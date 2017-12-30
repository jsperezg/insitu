# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceDetail, type: :model do
  let!(:default_vat) { create(:vat, :default, rate: 21) }
  let(:quantity) { nil }
  let(:price) { nil }
  let(:vat_rate) { nil }
  let(:discount) { nil }
  let(:invoice_detail) do
    InvoiceDetail.new(
      quantity: quantity,
      price: price,
      vat_rate: vat_rate,
      discount: discount
    )
  end

  before do
    invoice_detail.validate
  end

  context 'quantity' do
    context 'is nil' do
      it 'raises error' do
        expect(invoice_detail.errors).to have_key :quantity
      end
    end

    context 'is not a number' do
      let(:quantity) { 'asdf' }

      it 'raises error' do
        expect(invoice_detail.errors).to have_key :quantity
      end
    end

    context 'is zero' do
      let(:quantity) { 0 }

      it 'raises error' do
        expect(invoice_detail.errors).to have_key :quantity
      end
    end
  end

  context 'price' do
    context 'is nil' do
      it 'raises an error' do
        expect(invoice_detail.errors).to have_key :price
      end
    end

    context 'is not a number' do
      let(:price) { 'asdf' }

      it 'raises an error' do
        expect(invoice_detail.errors).to have_key :price
      end
    end

    context 'is negative' do
      let(:price) { -1 }

      it 'raises an error' do
        expect(invoice_detail.errors).to have_key :price
      end
    end
  end

  context 'vat rate' do
    context 'is not a number' do
      let(:vat_rate) { 'asdf' }

      it 'raises an error' do
        expect(invoice_detail.errors).to have_key :vat_rate
      end
    end

    context 'is lower than zero' do
      let(:vat_rate) { -1 }

      it 'raises an error' do
        expect(invoice_detail.errors).to have_key :vat_rate
      end
    end

    context 'is a decimal' do
      let(:vat_rate) { 1.1 }

      it 'raises an error' do
        expect(invoice_detail.errors).to have_key :vat_rate
      end
    end

    context 'fallback to default vat rate' do
      it 'vat_rate is initialized with default vat rate' do
        expect(invoice_detail.vat_rate).to eq(Vat.default.rate)
      end
    end
  end

  context 'discount' do
    it 'fallbacks to zero' do
      expect(invoice_detail.discount).to eq(0)
    end

    context 'is not a number' do
      let(:discount) { 'asdf' }

      it 'raises an error' do
        expect(invoice_detail.errors).to have_key :discount
      end
    end

    context 'is less than zero' do
      let(:discount) { -1 }

      it 'raises an error' do
        expect(invoice_detail.errors).to have_key :discount
      end
    end
  end

  context 'totals' do
    it 'total includes discount, vat, price and quantity' do
      r = InvoiceDetail.new(quantity: 1.0, price: 100.0, vat_rate: 21.0, discount: 10.0)
      expect(r.total).to eq(108.9)
    end
  end

  context 'removing invoice details' do
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
