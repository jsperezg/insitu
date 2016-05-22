class NotifyPaymentErrorMailer < ApplicationMailer
  def notify_payment_error(to)
    @error_message = error_message
    mail_to(to: to, subject: 'Notificación del servicio de renovación de InSitu/InSitu renewal service notification')
  end
end
