class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    title 'Blog'

    @pagy, @posts = pagy(posts)
    respond_to do |format|
      format.html
    end
  end

  def show
    redirect_to posts_url and return unless post.present?

    title post.title
    description post.description

    respond_to do |format|
      format.html
    end
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(permitted_params)
    @post.save

    respond_to do |format|
      format.turbo_stream do
        redirect_to post_path(@post.slug)
      end
      format.html
    end
  end

  def edit
    post
  end

  def update
    post = current_user.posts.find(params[:slug])
    post.update(permitted_params)

    redirect_to post_path(slug: post.slug)
  end

  def destroy
    current_user.posts.find(params[:slug]).destroy

    respond_to do |format|
      format.turbo_stream do
        redirect_to posts_url
      end
    end
  end

  private

  def posts
    @posts ||= Post.published.order(published_date: :desc)
  end

  def post
    @post ||= Post.find_by_slug(params[:slug])
  end

  def permitted_params
    params.require(:post).permit(:title, :content)
  end
end
