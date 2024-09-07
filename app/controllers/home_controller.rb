class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  after_action :track_action, only: %i[index]

  def index
    posts
    uploads
  end

  private

  def posts
    @posts ||= Post.order(published_date: :desc)
                   .limit(10)
  end

  def uploads
    @uploads ||= Upload.all
                       .order(created_at: :desc)
  end
end
