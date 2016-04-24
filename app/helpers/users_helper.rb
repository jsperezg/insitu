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

  def renew_subscription_link_tag
    if current_user.has_expired?
      message = I18n.t('users.account_expired_message')
      content_tag :div, class: 'row' do
        content_tag :p, class: 'col-xs-12' do
          link_to message, renew_user_path(current_user), class: 'text-danger'
        end
      end
    end
  end
end
