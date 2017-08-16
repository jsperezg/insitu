# frozen_string_literal: true

class SecuredController < ApplicationController
  before_action :authenticate_user!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, unless: proc { |c| c.request.format.json? }
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format.json? }
end
