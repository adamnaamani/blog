module Sluggable
  extend ActiveSupport::Concern

  def self.call(string)
    string.parameterize.truncate(80, omission: '') if string.present?
  end
end
