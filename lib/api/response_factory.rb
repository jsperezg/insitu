module Api
  class ResponseFactory
    def self.get_response_for(model)
      if model.valid?
        { error: false }
      else
        { error: true, errors: model.errors.full_messages }
      end
    end

    def self.error_response(message)
      { error: true, errors: [ message ] }
    end
  end
end