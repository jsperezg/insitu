var TimeLog = function (json) {
  extend(this, new ServiceDependantDetail(defined(json) ? json : this.emptyDetail()));
};

TimeLog.prototype.emptyDetail = function () {
  return {
    id: null,
    description: '',
    date: null,
    time_spent: null,
    service_id: null,
    invoice_detail_id: null
  };
};