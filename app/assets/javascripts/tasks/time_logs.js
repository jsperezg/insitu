var TimeLogs = function () {
  extend(this, new AbstractDetails());
};

TimeLogs.prototype.refresh = function () {
  var id = $('#task_id').val(),
      project_id = $('#task_project_id').val();

  if (defined(id) && id !== '') {
    return $.ajax('/api/v1/projects/' + project_id + '/tasks/' + id + '.json').success(function (data) {
      var i, l, details = [];

      for (i = 0, l = data.time_logs.length; i < l; i += 1) {
        details.push(new TimeLog(data.time_logs[i]));
      }

      this.details(details);
    }.bind(this));
  }

  return false;
};

TimeLogs.prototype.add = function () {
  this.details.unshift(new TimeLog());
};