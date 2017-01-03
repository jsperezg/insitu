//= require estimates/estimate_details

$(document).ready(function() {
  let estimateDetailsElement = document.getElementById('estimate_details'),
      estimateDetails = new EstimateDetails();

  ko.applyBindings(estimateDetails, estimateDetailsElement);

  let request = estimateDetails.refresh();
  if (request) {
    request.done(function () {
      if (estimateDetails.isEmpty()) {
        estimateDetails.add();
      }
    });
  } else {
    estimateDetails.add();
  }
});