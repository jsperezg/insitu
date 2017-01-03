class AbstractDetails {
  constructor() {
    this.details = ko.observableArray();
  }

  isEmpty() {
    return this.details().length === 0;
  }
}