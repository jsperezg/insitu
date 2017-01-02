//= require utils

var EstimateDetail = function (json) {
  this.service = { id: ko.observable(), description: ko.observable(), unit: { label_short: ko.observable() } };
  this.deleted = ko.observable(0);

  this.visible = ko.pureComputed(function() {
    return this.deleted() !== 1;
  }, this);

  this.json = defined(json) ? json : EstimateDetail.emptyDetail();
  ko.mapping.fromJS(this.json, {}, this);

  this.service_id.subscribe(function (newValue) {
    this.findService(newValue);
  }, this);

  this.quantity.subscribe(this.calculateTotal, this);
  this.price.subscribe(this.calculateTotal, this);
  this.discount.subscribe(this.calculateTotal, this);
};

EstimateDetail.prototype.findService = function (service_id) {
  if (this.service.id() !== parseInt(service_id, 10)) {
    $.ajax('/api/v1/services/' + service_id + '.json').success(function (data) {
      ko.mapping.fromJS(data, {}, this.service);

      this.updatePrice();
    }.bind(this));
  }
};

EstimateDetail.prototype.updatePrice = function () {
  if (this.mustApplySavedPrice()) {
    this.price(this.json.price);
  } else {
    this.price(this.service.price());
  }
};

EstimateDetail.prototype.mustApplySavedPrice = function () {
  return defined(this.json.service_id) && defined(this.json.price) && this.service_id() === this.json.service_id;
};

EstimateDetail.prototype.calculateTotal = function () {
  var value = this.quantity() * this.price() * ( 1 - (this.discount() / 100));

  if (defined(value)) {
    value = value.toFixed(2);
  }

  this.total(value);
};

EstimateDetail.prototype.markAsDeleted = function () {
  this.deleted(1);
};

EstimateDetail.emptyDetail = function () {
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