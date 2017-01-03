//= require tasks/time_log
//= require 'abstract-details'

class TimeLogs extends AbstractDetails {
  refresh() {
    let id = $('#task_id').val(),
        project_id = $('#project_id').val();

    if (defined(id) && id !== '') {
      return $.ajax('/api/v1/projects/' + project_id + '/tasks/' + id + '.json').success(function (data) {
        let i, l, details = [];

        for (i = 0, l = data.time_logs.length; i < l; i += 1) {
          details.push(new TimeLog(data.time_logs[i]));
        }

        this.details(details);
      }.bind(this));
    }

    return false;
  }

  add() {
    this.details.unshift(new TimeLog());
  }
}