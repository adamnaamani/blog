class HomeController < ApplicationController
  def index
    posts
  end

  private

  def posts
    @posts ||= Post.order(published_date: :desc)
                   .limit(10)
  end
end