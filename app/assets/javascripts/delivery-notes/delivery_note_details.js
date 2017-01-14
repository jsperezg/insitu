var DeliveryNoteDetails = function () {
  extend(this, new AbstractDetails());
};

DeliveryNoteDetails.prototype.refresh = function () {
  var id = $('#delivery_note_id').val();

  if (defined(id) && id !== '') {
    return $.ajax('/api/v1/delivery_notes/' + id + '.json').success(function (data) {
      var i, l, details = [];

      for (i = 0, l = data.delivery_note_details.length; i < l; i += 1) {
        details.push(new DeliveryNoteDetail(data.delivery_note_details[i]));
      }

      this.details(details);
    }.bind(this));
  }

  return false;
};

DeliveryNoteDetails.prototype.add = function() {
  this.details.unshift(new DeliveryNoteDetail());
};