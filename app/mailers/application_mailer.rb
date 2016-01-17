class ApplicationMailer < ActionMailer::Base
  require 'open-uri'

  default from: ENV['default_from']
  layout 'mailer'
end
