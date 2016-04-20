class AbstractSubscriptionValidator < ActiveRecord::Base
  self.abstract_class = true

  validate :subscription_validity

  protected

  def subscription_validity
    user = Thread.current[:user]
    if user.has_expired?
      errors.add(:base, I18n.t('activerecord.errors.messages.subscription_expired'))
    end
  end
end