require "open-uri"

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :omniauthable, omniauth_providers: %i[google_oauth2 twitter2]

  after_create :create_default_lists

  mount_uploader :image, ImageUploader

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  has_many :museums, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :lists, dependent: :destroy

  enum :role, { general: 0, admin: 1 }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email.presence || "twitter_user_#{auth.uid}@example.com"
      user.name = auth.info.name
      user.password = Devise.friendly_token[0, 20]

      if auth.info.image.present?
        begin
          user.remote_image_url = auth.info.image
        rescue => e
          Rails.logger.error("Failed to attach image: #{e.message}")
        end
      end
    end
  end

  private

  def create_default_lists
    lists.create(name: "行きたい", default: true)
    lists.create(name: "行った", default: true)
  end

  def password_required?
    new_record? || password.present?
  end
end
