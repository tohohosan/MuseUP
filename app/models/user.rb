class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_one_attached :image # プロフィール画像添付設定

  has_many :museums, dependent: :destroy
end
