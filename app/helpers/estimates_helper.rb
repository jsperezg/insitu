# frozen_string_literal: true

module EstimatesHelper
  def estimate_tr(estimate)
    content_tag(:tr, class: estimate_tr_class(estimate)) do
      yield
    end
  end

  def estimate_tr_class(estimate)
    if estimate.accepted?
      'success'
    elsif estimate.rejected?
      'danger'
    elsif estimate.sent?
      'info'
    else
      'active'
    end
  end
end
