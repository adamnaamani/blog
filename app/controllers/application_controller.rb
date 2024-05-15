class ApplicationController < ActionController::Base
  include Authenticatable
  include Searchable
  include Trackable
  include Paginatable
end
