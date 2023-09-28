class PostsController < ApplicationController
  def index
    posts
  end

  def new
    @post = Post.new
  end

  def show
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
    @posts ||= Post.all.order(created_at: :desc)
  end

  def post
    @post ||= Post.find(params[:id])
  end

  def permitted_params
    params.require(:post).permit(:title, :content)
  end
end
