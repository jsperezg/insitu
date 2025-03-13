# frozen_string_literal: true

module ResponseFactory
  extend ActiveSupport::Concern

  included do
    def get_response_for(model)
      if model.valid?
        { error: false }
      else
        { error: true, errors: model.errors.full_messages }
      end
    end

    def error_response(message)
      { error: true, errors: [message] }
    end
  end
end
