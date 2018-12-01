# frozen_string_literal: true

module Dashboard
  # Total invoiced grouped by service for the given period.
  class ServiceTotals
    attr_reader :interval

    def self.for_interval(interval)
      new(interval).query
    end

    def initialize(interval)
      @interval = interval
    end

    def query
      InvoiceDetail
        .includes(:invoice, :service)
        .where('invoices.date': interval)
        .group('IfNull(services.description, "n/a")')
        .sum('truncate((1 - discount / 100) * invoice_details.price * quantity, 2)')
    end
  end
end
