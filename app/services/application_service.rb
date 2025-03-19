# frozen_string_literal: true

class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def call
    raise NotImplementedError, "#{self.class} does not implement a `call` method."
  end
end
