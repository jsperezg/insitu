# frozen_string_literal: true

module TasksHelper
  def task_tr(task, &block)
    content_tag(:tr, class: task_tr_class(task), &block)
  end

  def task_tr_class(task)
    if !task.finish_date.nil?
      'success'
    elsif task.dead_line.nil? || task.dead_line > Date.current
      'active'
    elsif task.dead_line == Date.current
      'warning'
    else
      'danger'
    end
  end
end
