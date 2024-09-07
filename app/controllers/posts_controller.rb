class PostsController < ApplicationController
  include Postable

  skip_before_action :authenticate_user!, only: %i[index show]
  after_action :track_action, only: %i[index show]

  def index
    redirect_to root_url and return unless posts.any?

    title "Blog"

    posts
    respond_to do |format|
      format.html
    end
  end

  def show
    redirect_to root_url and return unless post.present?
    redirect_to root_url and return if post.draft? && !user_signed_in?

    title post.title
    description post.description
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(permitted_params)
    post.save

    redirect_to "/#{post.slug}"
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    return unless post.present?

    save_post

    redirect_to "/#{post.slug}", notice: "Post updated"
  end

  def destroy
    @post = current_user.posts.find(params[:id])

    return unless post.present?

    post.destroy

    respond_to do |format|
      format.turbo_stream do
        redirect_to posts_url
      end
    end
  end

  private

  def posts
    @posts ||= Post.published
                   .with_rich_text_content_and_embeds
                   .with_attached_images
                   .order(published_date: :desc)
                   .page(page)
  end

  def post
    @post ||= Post.with_rich_text_content_and_embeds
                  .with_attached_images
                  .find_by(slug: params[:slug])
  end

  def permitted_params
    params.require(:post).permit(:slug, :title, :content, :published_date)
  end
end
