class Post < ApplicationRecord
  has_many_attached :media

  has_rich_text :content

  enum :status, [:draft, :published, :archived]

  def description
    meta.select { |item| item['_yoast_wpseo_metadesc'] }.first&.values&.first
  end
end
