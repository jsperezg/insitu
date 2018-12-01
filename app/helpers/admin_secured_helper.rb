# frozen_string_literal: true

module AdminSecuredHelper
  def admin?
    current_user.role&.description == 'Administrator'
  end
end
