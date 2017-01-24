var AbstractDetail = function (json) {
  this.json = json;
  ko.mapping.fromJS(this.json, {}, this);

  this.deleted = ko.observable(0);
  this.visible = ko.pureComputed(function () {
    return this.deleted() !== 1;
  }, this);

  this.expanded = ko.observable(false);
  this.collapsed = ko.pureComputed(function () {
    return !this.expanded();
  }, this);
};

AbstractDetail.prototype.toggleExpanded = function () {
  this.expanded(!this.expanded());
};

AbstractDetail.prototype.markAsDeleted = function () {
  this.deleted(1);
};
