class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Authenticatable
  include Searchable
  include Trackable
end
