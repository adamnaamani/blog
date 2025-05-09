module Trackable
  extend ActiveSupport::Concern

  included do
    skip_before_action :track_ahoy_visit, if: :signed_in

    def signed_in
      user_signed_in?
    end

    def track_action
      return if user_signed_in? && current_user.admin?

      ahoy.track "Ran action", { path: request.fullpath }
    end
  end
end
