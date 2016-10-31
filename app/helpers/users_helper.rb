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
    elsif user.is_premium?
      tr_class = 'success'
    else
      tr_class = 'warning'
    end

    content_tag(:tr, class: tr_class) do
      yield
    end
  end

  def premium_subscription_link_tag
    unless current_user.is_premium?
      message = I18n.t('users.account_premium_message')
      content_tag :div, class: 'row' do
        content_tag :p, class: 'col-xs-12' do
          link_to message, renew_user_path(current_user), class: 'text-danger'
        end
      end
    end
  end
end
