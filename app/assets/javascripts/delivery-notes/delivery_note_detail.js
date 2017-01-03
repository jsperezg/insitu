//= require service-dependand-detail

class DeliveryNoteDetail extends ServiceDependandDetail {
  constructor (json) {
    super(json);
  }

  emptyDetail() {
    return {
      id: null,
      custom_description: '',
      quantity: null,
      price: null,
      invoice_detail_id: null,
      total: 0.0,
      service_id: null
    };
  }
}