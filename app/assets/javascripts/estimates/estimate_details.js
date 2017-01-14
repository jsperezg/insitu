var EstimateDetails = function () {
  extend(this, new AbstractDetails());
};

EstimateDetails.prototype.refresh = function () {
  var id = $('#estimate_id').val();

  if (defined(id) && id !== '') {
    return $.ajax('/api/v1/estimates/' + id + '.json').success(function (data) {
      var i, l, details = [];

      for (i = 0, l = data.estimate_details.length; i < l; i += 1) {
        details.push(new EstimateDetail(data.estimate_details[i]));
      }

      this.details(details);
    }.bind(this));
  }

  return false;
};

EstimateDetails.prototype.add = function () {
  this.details.unshift(new EstimateDetail());
};