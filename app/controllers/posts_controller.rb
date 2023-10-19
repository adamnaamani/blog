class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

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
    @post.save

    respond_to do |format|
      format.turbo_stream do
        redirect_to post_path(@post)
      end
      format.html
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    post = current_user.posts.find(params[:id])

    return unless post.present?

    post.assign_attributes(permitted_params)
    post.status = params[:status].to_sym if params[:status].present?
    post.save

    redirect_to "/#{post.slug}"
  end

  def destroy
    post = current_user.posts.find(params[:id])

    return unless post.present?

    post.destroy

    respond_to do |format|
      format.turbo_stream do
        redirect_to posts_url
      end
    end
  end

  def save
    post = current_user.posts.find(params[:id])

    return unless post.present?

    post.update(permitted_params)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def drafts
    @posts = Post.draft
                 .with_rich_text_content_and_embeds
                 .with_attached_images
                 .order(created_at: :desc)

    redirect_to root_url and return unless posts.any?

    title 'Drafts'

    @pagy, @posts = pagy(posts)
    respond_to do |format|
      format.html do
        render template: 'posts/index'
      end
    end
  end

  def purge_attachment
    return unless current_user.admin?

    attachment = ActiveStorage::Attachment.find(params[:id])

    if attachment.purge_later
      flash.now[:notice] = 'Attachment deleted'
    else
      flash.now[:alert] = 'Unprocessable'
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(:flash, partial: 'partials/flash'),
          turbo_stream.remove(attachment)
        ]
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
    params.require(:post).permit(:title, :content)
  end
end
