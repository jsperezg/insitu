# frozen_string_literal: true

module Dashboard
  # Total discounts for the given period.
  class DiscountTotals
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
        .sum('truncate((discount / 100) * price * quantity, 2)')
    end
  end
end