module Postable
  extend ActiveSupport::Concern

  included do
    def save
      @post = current_user.posts.find(params[:id])

      return unless post.present?

      save_post

      respond_to do |format|
        format.turbo_stream
      end
    end

    def drafts
      @posts = Post.draft
                   .with_rich_text_content_and_embeds
                   .with_attached_images
                   .order(created_at: :desc)
                   .page(page)

      redirect_to root_url and return unless posts.any?

      title "Drafts"

      respond_to do |format|
        format.html do
          render template: "posts/index"
        end
      end
    end

    def upload
      @post = current_user.posts.find(params[:id])

      post.images.attach(permitted_params[:images].compact_blank)

      redirect_to request.referrer
    end

    def purge_attachment
      return unless current_user.admin?

      attachment = ActiveStorage::Attachment.find(params[:id])

      if attachment.purge_later
        flash.now[:notice] = "Attachment deleted"
      else
        flash.now[:alert] = "Unprocessable"
      end

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:flash, partial: "partials/flash"),
            turbo_stream.remove(attachment)
          ]
        end
      end
    end

    def save_post
      post.assign_attributes(permitted_params)
      post.status = params[:status].to_sym if params[:status].present?
      post.meta = params[:meta] if params[:meta].present?
      post.save
    end
  end
end
