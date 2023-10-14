module Trackable
  extend ActiveSupport::Concern

  included do
    after_action :track_action, only: %i[index show]
  end

  private

  def track_action
    return if user_signed_in? && current_user.admin?

    ahoy.track "Ran action", request.path_parameters
  end
end
