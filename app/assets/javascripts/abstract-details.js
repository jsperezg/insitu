var AbstractDetails = function () {
  this.details = ko.observableArray();
};

AbstractDetails.prototype.isEmpty = function () {
  return this.details().length === 0;
};