//= require service-dependant-detail
//= require abstract-details
//= require service-dependant-detail
//= require_tree .
//= require_self

let onEditInvoiceDetailPageLoad = function () {
  let detailsElement = document.getElementById('invoice_details');

  if (detailsElement) {
    let details = new InvoiceDetails();
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

    if (!ko.contextFor(detailsElement)) {
      ko.applyBindings(details, detailsElement);
    }
  }
};

$(document).on("page:load", onEditInvoiceDetailPageLoad);
$(document).ready(onEditInvoiceDetailPageLoad);