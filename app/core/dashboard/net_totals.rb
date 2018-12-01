# frozen_string_literal: true

module Dashboard
  # Net invoiced for the given period.
  class NetTotals
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
        .sum('truncate((1 - discount / 100) * price * quantity, 2)')
    end
  end
end
