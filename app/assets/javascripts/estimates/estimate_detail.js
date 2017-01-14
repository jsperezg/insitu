var EstimateDetail = function (json) {
  extend(this, new ServiceDependantDetail(defined(json) ? json : this.emptyDetail()));
};

EstimateDetail.prototype.emptyDetail = function () {
  return {
    id: null,
    description: '',
    quantity: null,
    price: null,
    discount: 0,
    invoice_detail_id: null,
    total: 0.0,
    service_id: null
  };
};