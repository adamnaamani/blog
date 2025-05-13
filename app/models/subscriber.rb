class Subscriber < ApplicationRecord
  validates :email, presence: true,
                   uniqueness: true,
                   email: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :normalize_email

  private

  def normalize_email
    self.email = email.strip.downcase if email.present?
  end
end
