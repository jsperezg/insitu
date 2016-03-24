module AdminSecuredHelper
  def is_admin?
    current_user.role.try(:description) == 'Administrator'
  end
end
