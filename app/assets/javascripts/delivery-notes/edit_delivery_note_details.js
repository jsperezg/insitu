//= require delivery-notes/delivery_note_details

$(document).ready(function() {
  let detailsElement = document.getElementById('delivery_note_details'),
      details = new DeliveryNoteDetails();

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