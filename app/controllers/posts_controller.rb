class PostsController < ApplicationController
  include Postable

  def index
    redirect_to root_url and return unless posts.any?

    title 'Blog'

    @pagy, @posts = pagy(posts)
    respond_to do |format|
      format.html
    end
  end

  def show
    redirect_to posts_url and return unless post.present?
    redirect_to posts_url and return if post.draft? && !user_signed_in?

    title post.title
    description post.description

    respond_to do |format|
      format.html
    end
  end

  def new
    @post = current_user.posts.new
    post.save(validate: false)

    redirect_to edit_post_path(post)
  end

  def create
    @post = current_user.posts.new(permitted_params)
    post.save

    respond_to do |format|
      format.turbo_stream do
        redirect_to post_path(post)
      end
      format.html
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    return unless post.present?

    save_post

    flash[:notice] = 'Post updated'

    redirect_to "/#{post.slug}"
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
  end

  def post
    @post ||= Post.with_rich_text_content_and_embeds
                  .with_attached_images
                  .find_by(slug: params[:slug])
  end

  def permitted_params
    params.require(:post).permit(:slug, :title, :content)
  end
end
