class UploadsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    uploads
  end

  def create
    upload = current_user.uploads.create(
      name: permitted_params[:name],
      category: permitted_params[:category]
    )
    upload.image.attach(permitted_params[:image])

    redirect_to request.referrer
  end

  def purge_attachment
    return unless current_user.admin?

    upload = Upload.find(params[:id])
    upload.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(upload)
        ]
      end
    end
  end

  private

  def uploads
    @uploads ||= Upload.all.order(created_at: :desc)
  end

  def permitted_params
    params.require(:upload).permit(:name, :category, :image)
  end
end
