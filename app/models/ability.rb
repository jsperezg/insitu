# frozen_string_literal: true

# This class defines the abilities and permissions for all users
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    define_admin_permissions(user)
    define_user_permissions(user)
  end

  def define_admin_permissions(user)
    return unless user.administrator?

    alias_action :index, :show, :new, :create, :edit, :update, :destroy, to: :crud

    can :crud, User if user.administrator?
    can :ban, User do |insitu_user|
      user.administrator? && !insitu_user.administrator?
    end

    can :manage, Plan if user.administrator?
  end

  def define_user_permissions(user)
    return if user.administrator?

    can :destroy, User do |insitu_user|
      user.id == insitu_user.id
    end
  end
end
