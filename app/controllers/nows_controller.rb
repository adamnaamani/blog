class NowsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    nows
  end

  def show
    now
  end

  def new
    @now = current_user.nows.new
  end

  def create
    @now = current_user.nows.new(permitted_params)
    now.save

    respond_to do |format|
      format.turbo_stream do
        redirect_to now_path(now)
      end
      format.html
    end
  end

  def edit
    now
  end

  def update
    now.update(permitted_params)
  end

  private

  def nows
    @nows ||= Now.published
                 .with_rich_text_content_and_embeds
                 .order(created_at: :desc)
                 .last
  end

  def now
    @now ||= Now.with_rich_text_content_and_embeds
                .find(params[:id])
  end

  def permitted_params
    params.require(:now).permit(:content)
  end
end
