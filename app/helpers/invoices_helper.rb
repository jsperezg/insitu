# frozen_string_literal: true

module InvoicesHelper
  def invoice_tr(invoice)
    content_tag(:tr, class: tr_class_for(invoice)) do
      yield
    end
  end

  def tr_class_for(invoice)
    return 'active' if invoice.amending_invoice?
    return 'success' if invoice.paid?
    return 'danger' if invoice.default?
    return 'info' if invoice.sent?
    'active'
  end
end
