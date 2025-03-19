# frozen_string_literal: true

module EstimatesHelper
  def estimate_tr(estimate, &block)
    content_tag(:tr, class: estimate_tr_class(estimate), &block)
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
