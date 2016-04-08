module UsersHelper
  def validity_date(object, options = {})
    object.present? ? localize(object, options) : t('users.perpetual')
  end

  def user_tr(user)

    if user.is_active?
      tr_class = 'success'
    elsif user.is_about_to_expire?
      tr_class = 'warning'
    else
      tr_class = 'danger'
    end

    content_tag(:tr, class: tr_class) do
      yield
    end
  end
end
