class DeliveryNoteDetails extends AbstractDetails {
  refresh() {
    let id = $('#delivery_note_id').val();

    if (defined(id) && id !== '') {
      return $.ajax('/api/v1/delivery_notes/' + id + '.json').success(function (data) {
        let i, l, details = [];

        for (i = 0, l = data.delivery_note_details.length; i < l; i += 1) {
          details.push(new DeliveryNoteDetail(data.delivery_note_details[i]));
        }

        this.details(details);
      }.bind(this));
    }

    return false;
  }

  add() {
    this.details.unshift(new DeliveryNoteDetail());
  }
}