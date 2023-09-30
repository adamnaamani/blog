class PostsController < ApplicationController
  def index
    title 'Blog'
    posts

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def new
    @post = Post.new
  end

  def show
    redirect_to posts_url and return unless post.present?

    title post.title
    description post.description

    post
  end

  def create
    @post = Post.new(permitted_params)
    @post.save

    respond_to do |format|
      format.turbo_stream do
        redirect_to post_path(@post)
      end
      format.html
    end
  end

  def edit
    post
  end

  def update
    post.update(permitted_params)
  end

  def destroy
    post.destroy

    respond_to do |format|
      format.turbo_stream do
        redirect_to root_url
      end
    end
  end

  private

  def posts
    @posts ||= Post.order(published_date: :desc)
  end

  def post
    @post ||= Post.find_by_slug(params[:slug])
  end

  def permitted_params
    params.require(:post).permit(:title, :content)
  end
end
