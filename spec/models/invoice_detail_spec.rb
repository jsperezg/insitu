# frozen_string_literal: true

require 'rails_helper'

describe InvoiceDetail, type: :model do
  subject { create :invoice_detail }

  it { is_expected.to be_valid }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:vat_rate).is_greater_than_or_equal_to(0).only_integer }
  end

  describe 'default values' do
    context 'when vat rate is nil' do
      subject(:invoice_detail) { create :invoice_detail, vat_rate: nil }

      before do
        create(:vat, :default, rate: 21)
      end

      it { is_expected.to be_valid }

      it 'fallbacks to default vat rate' do
        expect(invoice_detail.vat_rate).to eq(21)
      end
    end

    context 'when discount is nil' do
      subject(:invoice_detail) { create :invoice_detail, discount: nil }

      it { is_expected.to be_valid }

      it 'fallbacks to zero' do
        expect(invoice_detail.discount).to be_zero
      end
    end
  end

  describe '#total' do
    subject(:invoice_detail) { described_class.new(quantity: 1.0, price: 100.0, vat_rate: 21.0, discount: 10.0) }

    it 'total includes discount, vat, price and quantity' do
      expect(invoice_detail.total).to eq(108.9)
    end
  end

  context 'when removing invoice details' do
    subject(:invoice_detail) { create(:invoice_detail) }

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
