//= require service-dependant-detail
//= require abstract-details
//= require_tree .
//= require_self

let onEditTimeLogsPageLoad = function () {
  let detailsElement = document.getElementById('time_logs');

  if (detailsElement) {
    let details = new TimeLogs(),
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

$(document).on("page:load", onEditTimeLogsPageLoad);
$(document).ready(onEditTimeLogsPageLoad);