var InvoiceDetails = function () {
  extend(this, new AbstractDetails());
};

InvoiceDetails.prototype.refresh = function () {
  var id = $('#invoice_id').val();

  if (defined(id) && id !== '') {
    return $.ajax('/api/v1/invoices/' + id + '.json').success(function (data) {
      var i, l, details = [];

      for (i = 0, l = data.invoice_details.length; i < l; i += 1) {
        details.push(new InvoiceDetail(data.invoice_details[i]));
      }

      this.details(details);
    }.bind(this));
  }

  return false;
};

InvoiceDetails.prototype.add = function () {
  this.details.unshift(new InvoiceDetail());
};