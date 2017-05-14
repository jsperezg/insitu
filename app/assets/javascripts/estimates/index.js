//= require abstract-details
//= require service-dependant-detail
//= require_tree .
//= require_self

var onEditEstimatePageLoad = function () {
  var estimateDetailsElement = document.getElementById('estimate_details');

  if (estimateDetailsElement) {
    var estimateDetails = new EstimateDetails(),
        request = estimateDetails.refresh();

    if (request) {
      request.done(function () {
        if (estimateDetails.isEmpty()) {
          estimateDetails.add();
        }
      });
    } else {
      estimateDetails.add();
    }

    if (!ko.contextFor(estimateDetailsElement)) {
      ko.applyBindings(estimateDetails, estimateDetailsElement);
    }
  }
};

document.addEventListener("turbolinks:load", onEditEstimatePageLoad);