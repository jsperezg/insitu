module UsersHelper
  def validity_date(user, options = {})
    if user.banned?
      'Banned'
    else
      user.valid_until.nil? ? t('users.perpetual') : localize(user.valid_until, options)
    end
  end

  def user_tr(user)

    if user.banned?
      tr_class = 'danger'
    elsif user.is_active?
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
