# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_filter :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    protected

    def after_sign_in_path_for(resource)
      if resource.is_a?(User) && resource.banned?
        sign_out resource
        # flash[:error] = "This account has been suspended for violation of...."
        root_path
      else
        super
      end
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.for(:sign_in) << :attribute
    # end
  end
end
