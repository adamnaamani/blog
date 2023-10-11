class Post < ApplicationRecord
  belongs_to :user

  has_many_attached :images

  has_rich_text :content

  enum :status, [:draft, :published, :archived]

  validates :slug, uniqueness: true

  def description
    meta_description = meta.select { |item| item['_yoast_wpseo_metadesc'] }

    return unless meta_description.present?

    meta_description.first.values.first
  end
end
