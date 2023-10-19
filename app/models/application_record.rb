class ApplicationRecord < ActiveRecord::Base
  include Sluggable

  primary_abstract_class
end
