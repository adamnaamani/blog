class AboutController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  after_action :track_action, only: %i[index]

  def index; end
end
