//= require abstract-detail

class ServiceDependandDetail extends AbstractDetail {
  constructor(json) {
    super(json);

    this.service = { id: ko.observable(), description: ko.observable(), unit: { label_short: ko.observable() } };

    this.service_id.subscribe(function (newValue) {
      this.findService(newValue);
    }, this);
  }

  findService(service_id) {
    if (this.service.id() !== parseInt(service_id, 10)) {
      $.ajax('/api/v1/services/' + service_id + '.json').success(function (data) {
        ko.mapping.fromJS(data, {}, this.service);

        this.updatePrice();
      }.bind(this));
    }
  }

  updatePrice() {
    if (this.mustApplySavedPrice()) {
      this.price(this.json.price);
    } else {
      this.price(this.service.price());
    }
  }

  mustApplySavedPrice() {
    return defined(this.json.service_id) && defined(this.json.price) && this.service_id() === this.json.service_id;
  };
}