class Post < ApplicationRecord
  belongs_to :user

  has_many_attached :images

  has_rich_text :content

  enum :status, [:draft, :published, :archived]

  validates :title, presence: true
  validates :slug, uniqueness: true

  before_update :create_slug, if: :title_changed?

  def description
    return unless meta.present?

    meta_description = meta.select { |item| item['_yoast_wpseo_metadesc'] }

    return unless meta_description.present?

    meta_description.first.values.first
  end

  private

  def create_slug
    self.slug = Sluggable.call(title)
  end
end
