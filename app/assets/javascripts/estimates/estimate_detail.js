//= require service-dependand-detail

class EstimateDetail extends ServiceDependandDetail {
  constructor (json) {
    super(json);

    this.quantity.subscribe(this.calculateTotal, this);
    this.price.subscribe(this.calculateTotal, this);
    this.discount.subscribe(this.calculateTotal, this);
  }

  calculateTotal() {
    let value = this.quantity() * this.price() * ( 1 - (this.discount() / 100));

    if (defined(value)) {
      value = value.toFixed(2);
    }

    this.total(value);
  };

  markAsDeleted() {
    this.deleted(1);
  }

  emptyDetail() {
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
  }
}