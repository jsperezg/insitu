//= require service-dependand-detail

class InvoiceDetail extends ServiceDependandDetail {
  constructor (json) {
    super(json);
  }

  emptyDetail() {
    return {
      id: null,
      description: '',
      quantity: null,
      price: null,
      vat_rate: null,
      discount: 0,
      invoice_detail_id: null,
      total: 0.0,
      service_id: null
    };
  }
}