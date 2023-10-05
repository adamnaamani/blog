class Post < ApplicationRecord
  belongs_to :user

  has_many_attached :images

  has_rich_text :content

  enum :status, [:draft, :published, :archived]

  validates :slug, uniqueness: true

  def description
    meta&.select { |item| item['_yoast_wpseo_metadesc'] }.first&.values&.first
  end
end
