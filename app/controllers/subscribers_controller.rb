class SubscribersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]

  def create
    return unless permitted_params[:email].present?

    subscriber = Subscriber.new(permitted_params)

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

  def permitted_params
    params.require(:subscriber).permit(:email)
  end
end
