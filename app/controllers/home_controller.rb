class HomeController < ApplicationController
  def index
    posts
  end

  private

  def posts
    @posts ||= Post.limit(3)
  end
end