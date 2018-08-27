# frozen_string_literal: true

module Dashboard
  # Total retained for the given period. Only applies for spanish freelancers.
  class TaxTotals
    attr_reader :interval

    def self.for_interval(interval)
      new(interval).query
    end

    def initialize(interval)
      @interval = interval
    end

    def query
      InvoiceDetail
        .includes(invoice: [:customer])
        .where('invoices.date': interval)
        .where.not('customers.irpf': nil)
        .sum('truncate((1 - discount / 100) * price * quantity * (customers.irpf / 100), 2)')
    end
  end
end