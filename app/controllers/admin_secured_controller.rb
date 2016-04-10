class AdminSecuredController < SecuredController
  include AdminSecuredHelper

  before_action :check_admin_role

  private

  def check_admin_role
    unless is_admin?
      # A la puta calle cabrón
      sign_out resource
      root_path
    end
  end
end
