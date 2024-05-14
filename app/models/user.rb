class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable

  has_rich_text :content

  has_many :nows
  has_many :posts
  has_many :uploads
  has_many :visits, class_name: "Ahoy::Visit"
end
