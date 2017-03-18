var DeliveryNoteDetail = function (json) {
  extend(this, new ServiceDependantDetail(defined(json) ? json : this.emptyDetail()));
};

DeliveryNoteDetail.prototype.emptyDetail = function () {
  return {
    id: null,
    description: '',
    quantity: null,
    price: null,
    invoice_detail_id: null,
    total: 0.0,
    service_id: null
  };
};