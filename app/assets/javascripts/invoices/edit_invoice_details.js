//= require invoices/invoice_details

$(document).ready(function() {
  let detailsElement = document.getElementById('invoice_details'),
      details = new InvoiceDetails();

  ko.applyBindings(details, detailsElement);

  let request = details.refresh();
  if (request) {
    request.done(function () {
      if (details.isEmpty()) {
        details.add();
      }
    });
  } else {
    details.add();
  }
});