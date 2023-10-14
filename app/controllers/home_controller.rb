class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    posts
  end

  private

  def posts
    @posts ||= Post.order(published_date: :desc)
                   .limit(10)
  end
end