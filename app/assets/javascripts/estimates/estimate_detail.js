//= require service-dependant-detail

class EstimateDetail extends ServiceDependantDetail {
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