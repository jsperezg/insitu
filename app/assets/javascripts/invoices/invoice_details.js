

'use strict';

class InvoiceDetails extends AbstractDetails {
  refresh() {
    let id = $('#invoice_id').val();

    if (defined(id) && id !== '') {
      return $.ajax('/api/v1/invoices/' + id + '.json').success(function (data) {
        let i, l, details = [];

        for (i = 0, l = data.invoice_details.length; i < l; i += 1) {
          details.push(new InvoiceDetail(data.invoice_details[i]));
        }

        this.details(details);
      }.bind(this));
    }

    return false;
  }

  add() {
    this.details.unshift(new InvoiceDetail());
  }
}