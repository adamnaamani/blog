class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable

  has_rich_text :content

  has_many_attached :images

  has_many :visits, class_name: "Ahoy::Visit"
  has_many :posts
end
