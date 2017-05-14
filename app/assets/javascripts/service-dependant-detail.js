//=require abstract-detail
//=require vats

var ServiceDependantDetail = function (json) {
  extend(this, new AbstractDetail(json));

  this.service = {id: ko.observable(), description: ko.observable(), unit: {label_short: ko.observable()}};

  this.detailDescription = ko.pureComputed(function () {
    var label = [];

    if (defined(this.service) && defined(this.service.description()) && this.service.description() !== "") {
      label.push(this.service.description());
    }

    if (defined(this.description()) && this.description() !== "") {
      label.push(this.description());
    }

    return label.join(": ");
  }, this);

  this.service_id.subscribe(function (newValue) {
    this.findService(newValue);
  }, this);

  if (defined(this.total)) {
    if (!defined(this.discount)) {
      this.discount = ko.observable(0);
    }

    if (!defined(this.vat_rate)) {
      this.vat_rate = ko.observable(0);
    }

    if (!defined(this.vat_rate())) {
      Vats.findDefaultVat(function (defaultVat) {
        this.vat_rate(defaultVat.rate);
      }.bind(this));
    }

    this.quantity.subscribe(this.calculateTotal, this);
    this.price.subscribe(this.calculateTotal, this);
    this.discount.subscribe(this.calculateTotal, this);
    this.vat_rate.subscribe(this.calculateTotal, this);
  }
};

ServiceDependantDetail.prototype.calculateTotal = function () {
  var value = this.quantity() * this.price() * ( 1 - (this.discount() / 100))  * ( 1 + (this.vat_rate() / 100));

  if (defined(value)) {
    value = value.toFixed(2);
  }

  this.total(value);
};

ServiceDependantDetail.prototype.findService = function (service_id) {
  if (defined(service_id) && service_id !== "" && this.service.id() !== parseInt(service_id, 10)) {
    $.ajax('/api/v1/services/' + service_id + '.json').success(function (data) {
      ko.mapping.fromJS(data, {}, this.service);

      if (defined(this.total)) {
        this.updatePrice();
      }
    }.bind(this));
  } else {
    this.service.id(null);
    this.service.description(null);
  }
};

ServiceDependantDetail.prototype.updatePrice = function () {
  if (this.mustApplySavedPrice()) {
    this.price(this.json.price);
  } else {
    this.price(this.service.price());
  }
};

ServiceDependantDetail.prototype.mustApplySavedPrice = function () {
  return defined(this.json.service_id) && defined(this.json.price) && parseInt(this.service_id(), 10) === parseInt(this.json.service_id, 10);
};
