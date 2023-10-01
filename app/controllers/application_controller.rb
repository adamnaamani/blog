class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Searchable
end
