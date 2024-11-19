class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  after_create :create_default_lists

  has_one_attached :image # プロフィール画像添付設定

  has_many :museums, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :lists, dependent: :destroy

  private

  def create_default_lists
    lists.create(name: "行きたい", default: true)
    lists.create(name: "行った", default: true)
  end
end
