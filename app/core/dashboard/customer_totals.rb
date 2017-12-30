# frozen_string_literal: true

module Dashboard
  # Total invoiced grouped by customer for the given period.
  class CustomerTotals
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
        .group('customers.name')
        .sum('truncate((1 - discount / 100) * price * quantity, 2)')
    end
  end
end