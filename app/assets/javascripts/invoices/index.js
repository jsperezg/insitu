//= require service-dependant-detail
//= require abstract-details
//= require service-dependant-detail
//= require_tree .
//= require_self

var onEditInvoiceDetailPageLoad = function () {
  var detailsElement = document.getElementById('invoice_details');

  if (detailsElement) {
    var details = new InvoiceDetails(),
        request = details.refresh();

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

$(document).on("turbolinks:load", onEditInvoiceDetailPageLoad);