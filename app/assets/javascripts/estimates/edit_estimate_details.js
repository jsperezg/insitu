//= require estimates/estimate_details

$(document).ready(function() {
  var estimateDetailsElement = document.getElementById('estimate_details'),
      estimateDetails = new EstimateDetails();

  ko.applyBindings(estimateDetails, estimateDetailsElement);

  var request = estimateDetails.refresh();
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