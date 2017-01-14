//= require abstract-details
//= require_tree .
//= require_self

let onDeliveryNoteEditPageLoad = function () {
  let detailsElement = document.getElementById('delivery_note_details');

  if (detailsElement) {
    let details = new DeliveryNoteDetails(),
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

$(document).on("page:load", onDeliveryNoteEditPageLoad);
$(document).ready(onDeliveryNoteEditPageLoad);