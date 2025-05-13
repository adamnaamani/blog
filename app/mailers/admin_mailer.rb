class AdminMailer < ApplicationMailer
  def new_subscriber(subscriber)
    @subscriber = subscriber
    @admin = User.where(admin: true)
                 .first
                 .email

    mail(
      to: @admin,
      subject: "New Subscriber: #{@subscriber.email}"
    )
  end
end
