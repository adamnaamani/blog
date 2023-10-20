class Post < ApplicationRecord
  belongs_to :user

  has_rich_text :content

  has_many_attached :images

  enum :status, %i[draft published archived]

  validates :title, presence: true
  validates :slug, uniqueness: true

  before_update :create_slug, if: :title_changed?

  def description
    return unless meta.present?

    metadesc = meta.select { |item| item['_yoast_wpseo_metadesc'] }
    description = meta.select { |item| item['description'] }

    if metadesc.present?
      metadesc.first.values.first
    elsif description.present?
      description.values.first
    end
  end

  private

  def create_slug
    self.slug = Sluggable.call(title)
  end
end
