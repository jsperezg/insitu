class InvoiceGenerator
  attr_accessor :payment_method

  def initialize
    @payment_method = PaymentMethod.find_by(default: true) || PaymentMethod.first
    raise 'payment_methods.not_found' unless @payment_method
  end

  def from_estimate(estimate)
    Invoice.transaction do
      unless estimate.accepted?
        estimate.estimate_status = EstimateStatus.find_by(name: 'estimate_status.accepted')
        estimate.save!
      end

      invoice = Invoice.create(
        date: Date.today,
        payment_date: Date.today + 15.days,
        customer_id: estimate.customer_id,
        payment_method_id: @payment_method.id
      )

      # Iterate over estimate details.
      details = EstimateDetail
                  .includes(service: [:vat])
                  .where(estimate_id: estimate.id, invoice_detail_id: nil)
      details.each do |detail|
        invoice_detail = InvoiceDetail.create(
          invoice_id: invoice.id,
          service_id: detail.service_id,
          vat_rate: detail.service.vat.rate,
          price: detail.price,
          discount: detail.discount,
          description: detail.description,
          quantity: detail.quantity
        )

        detail.invoice_detail_id = invoice_detail.id
        detail.save!
      end

      raise 'estimates.nothing_to_invoice' if invoice.invoice_details.empty?

      return invoice
    end
  end
end