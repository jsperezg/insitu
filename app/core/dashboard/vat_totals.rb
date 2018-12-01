# frozen_string_literal: true

module Dashboard
  # VAT totals for the given period.
  class VatTotals
    attr_reader :interval

    def self.for_interval(interval)
      new(interval).query
    end

    def initialize(interval)
      @interval = interval
    end

    def query
      InvoiceDetail
        .includes(:invoice)
        .where('invoices.date': interval)
        .where.not(vat_rate: 0)
        .group('concat(vat_rate, "%")')
        .sum('truncate((1 - discount / 100) * price * quantity * (vat_rate / 100), 2)')
    end
  end
end
