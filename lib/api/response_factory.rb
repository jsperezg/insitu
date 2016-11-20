module Api
  class ResponseFactory
    def self.get_response_for(model)
      if model.valid?
        { error: false }
      else
        { error: true, errors: model.errors.full_messages }
      end
    end
  end
end