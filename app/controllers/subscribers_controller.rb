class SubscribersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]

  def create
    return unless permitted_params[:email].present?

    if subscriber.save
      label = "Subscribed! 🎉"
    else
      label = subscriber.errors.full_messages.join(", ")
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(:email, partial: "partials/email", locals: { label: })
        ]
      end
    end
  end

  private

  def subscriber
    @subscriber ||= Subscriber.new(permitted_params)
  end

  def send_admin_email(subscriber)
    AdminMailer.new_subscriber(subscriber).deliver_now
  end

  def permitted_params
    params.require(:subscriber).permit(:email)
  end
end
