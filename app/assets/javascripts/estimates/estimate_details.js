//= require estimates/estimate_detail
//= require 'abstract-details'

class EstimateDetails extends AbstractDetails {
  refresh() {
    let id = $('#estimate_id').val();

    if (defined(id) && id !== '') {
      return $.ajax('/api/v1/estimates/' + id + '.json').success(function (data) {
        let i, l, details = [];

        for (i = 0, l = data.estimate_details.length; i < l; i += 1) {
          details.push(new EstimateDetail(data.estimate_details[i]));
        }

        this.details(details);
      }.bind(this));
    }

    return false;
  }

  add() {
    this.details.unshift(new EstimateDetail());
  }
}