module Trackable
  extend ActiveSupport::Concern

  included do
    # Remove the skip_before_action to track visits for all users
    # skip_before_action :track_ahoy_visit, if: :signed_in

    def signed_in
      user_signed_in?
    end

    def track_action
      # Track both visits and events for all users except admins
      return if user_signed_in? && current_user.admin?

      ahoy.track "Page view", { path: request.fullpath }
    end
  end
end
