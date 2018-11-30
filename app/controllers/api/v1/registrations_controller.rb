# frozen_string_literal: true

class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params.merge(terms_of_service: true))
    resource.skip_confirmation!
    if resource.save
      sign_in resource

      resource.reload

      render status: :ok,
             json: {
               success: true,
               info: 'Registered',
               data: { user: resource, auth_token: current_user.authentication_token }
             }
    else
      render status: :unprocessable_entity,
             json: {
               success: false,
               info: resource.errors,
               data: {}
             }
    end
  end
end
