# frozen_string_literal: true

class AdminSecuredController < SecuredController
  include AdminSecuredHelper

  before_action :check_admin_role

  private

  def check_admin_role
    return if admin?

    sign_out current_user
    redirect_to new_user_session_path
  end
end
