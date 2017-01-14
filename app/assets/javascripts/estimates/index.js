//= require abstract-details
//= require service-dependant-detail
//= require_tree .
//= require_self

let onEditEstimatePageLoad = function () {
  let estimateDetailsElement = document.getElementById('estimate_details');

  if (estimateDetailsElement) {
    let estimateDetails = new EstimateDetails(),
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

$(document).on("page:load", onEditEstimatePageLoad);
$(document).ready(onEditEstimatePageLoad);