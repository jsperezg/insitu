class AdminSecuredController < SecuredController
  include AdminSecuredHelper

  before_action :check_admin_role

  private

  def check_admin_role
    unless is_admin?
      render status: :unauthorized
    end
  end
end
