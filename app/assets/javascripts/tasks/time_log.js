

class TimeLog extends ServiceDependantDetail {
  emptyDetail() {
    return {
      id: null,
      description: '',
      date: null,
      time_spent: null,
      service_id: null,
      invoice_detail_id: null
    };
  }
}