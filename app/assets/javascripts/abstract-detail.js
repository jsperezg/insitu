//= require utils

class AbstractDetail {
  constructor (json) {
    this.json = defined(json) ? json : this.emptyDetail();
    ko.mapping.fromJS(this.json, {}, this);

    this.deleted = ko.observable(0);
    this.visible = ko.pureComputed(function() {
      return this.deleted() !== 1;
    }, this);
  }

  emptyDetail() {
    return {};
  }
}