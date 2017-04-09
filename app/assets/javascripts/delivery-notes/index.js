//= require abstract-details
//= require_tree .
//= require_self

var onDeliveryNoteEditPageLoad = function () {
  var detailsElement = document.getElementById('delivery_note_details');

  if (detailsElement) {
    var details = new DeliveryNoteDetails(),
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

$(document).on("turbolinks:load", onDeliveryNoteEditPageLoad);
$(document).ready(onDeliveryNoteEditPageLoad);