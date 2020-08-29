# frozen_string_literal: true

module TasksHelper
  def task_tr(task)
    content_tag(:tr, class: task_tr_class(task)) do
      yield
    end
  end

  def task_tr_class(task)
    if !task.finish_date.nil?
      'success'
    elsif task.dead_line.nil? || task.dead_line > Date.today
      'active'
    elsif task.dead_line == Date.today
      'warning'
    else
      'danger'
    end
  end
end
