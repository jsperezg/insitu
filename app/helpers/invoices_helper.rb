module InvoicesHelper
  def invoice_tr(invoice)

    if invoice.paid?
      tr_class = 'success'
    elsif invoice.default?
      tr_class = 'danger'
    elsif invoice.sent?
      tr_class = 'info'
    else
      tr_class = 'active'
    end

    content_tag(:tr, class: tr_class) do
      yield
    end
  end
end
