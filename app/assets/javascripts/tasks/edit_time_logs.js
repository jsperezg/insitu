//= require tasks/time_logs

let onPageLoad = function () {
  let detailsElement = document.getElementById('time_logs'),
      details = new TimeLogs();

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
};

$(document).on("page:load", onPageLoad);
$(document).ready(onPageLoad);