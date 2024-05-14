class Now < ApplicationRecord
  belongs_to :user

  has_rich_text :content

  enum :status, %i[draft published archived]
end
