module Paginatable
  extend ActiveSupport::Concern

  included do
    def page
      @page ||= params[:page] || 0
    end

    def per
      @per ||= 20
    end
  end
end
