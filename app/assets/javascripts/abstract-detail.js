var AbstractDetail = function (json) {
  this.json = json;
  ko.mapping.fromJS(this.json, {}, this);

  this.deleted = ko.observable(0);
  this.visible = ko.pureComputed(function () {
    return this.deleted() !== 1;
  }, this);
};

AbstractDetail.prototype.markAsDeleted = function () {
  this.deleted(1);
};
