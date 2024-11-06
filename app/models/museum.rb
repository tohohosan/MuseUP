class Museum < ApplicationRecord
  belongs_to :user
  has_many :museum_categories, dependent: :destroy
  has_many :categories, through: :museum_categories
  has_many_attached :images

  geocoded_by :address
  after_validation :geocode

  validates :name, :address, :description, presence: true
  validates :categories, presence: { message: "カテゴリを少なくとも1つ選択してください" }
  validates :name, length: { maximum: 100, message: "名前は100文字以内で入力してください" }
  validates :description, length: { maximum: 500, message: "説明は500文字以内で入力してください" }

  validate :validate_image_count
  validate :validate_address

  private

  # 画像が4枚以内であることを確認するカスタムバリデーション
  def validate_image_count
    if images.attached? && images.size > 4
      errors.add(:images, "画像は最大4枚までアップロードできます")
    end
  end

  def validate_address
    geocoded = Geocoder.search(address)
    unless geocoded&.first&.coordinates.present?
      errors.add(:address, 'が存在しません') # 「住所が存在しません」と表示される
    end
  end
end
