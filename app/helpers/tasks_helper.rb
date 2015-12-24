module TasksHelper
  def task_tr(task)
    if task.finished
      tr_class = 'success'
    elsif task.dead_line.nil? || task.dead_line > Date.today
      tr_class = 'active'
    elsif task.dead_line == Date.today
      tr_class = 'warning'
    else
      tr_class = 'danger'
    end

    content_tag(:tr, class: tr_class) do
      yield
    end
  end
end
