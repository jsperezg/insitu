module EstimatesHelper
  def estimate_tr(estimate)

    if estimate.accepted?
      tr_class = 'success'
    else
      if estimate.rejected?
        tr_class = 'danger'
      elsif estimate.sent?
        tr_class = 'info'
      else
        tr_class = 'active'
      end
    end

    content_tag(:tr, class: tr_class) do
      yield
    end
  end
end
