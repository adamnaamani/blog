class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  def not_found
    title I18n.t('errors.not_found.title')

    render status: 404
  end

  def unprocessable
    title I18n.t('errors.unprocessable.title')

    render status: 422
  end

  def internal_server
    title I18n.t('errors.internal_server.title')

    render status: 500
  end
end
