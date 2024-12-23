class Museum < ApplicationRecord
  belongs_to :user
  has_many :museum_categories, dependent: :destroy
  has_many :categories, through: :museum_categories
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  has_many :reviews
  has_many :list_museums, dependent: :destroy
  has_many :lists, through: :list_museums
  has_many :notes, dependent: :destroy

  geocoded_by :address
  if Rails.env.test?
    after_validation :mock_geocode, if: ->(obj) { obj.address.present? && obj.latitude.blank? }
  else
    after_validation :geocode, if: ->(obj) { obj.address.present? && obj.latitude.blank? }
  end

  validates :name, :address, :description, presence: true
  validates :categories, presence: { message: "を少なくとも1つ選択してください" }
  validates :name, length: { maximum: 100, message: "名前は100文字以内で入力してください" }
  validates :description, length: { maximum: 500, message: "説明は500文字以内で入力してください" }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "が有効なURL形式ではありません" }, allow_blank: true

  validate :must_have_at_least_one_category
  validate :validate_image_count
  validate :validate_address, unless: -> { Rails.env.test? }

  private

  def must_have_at_least_one_category
    errors.add(:categories, "を少なくとも1つ選択してください") if categories.empty?
  end

  # 画像が4枚以内であることを確認するカスタムバリデーション
  def validate_image_count
    if images.size > 4
      errors.add(:images, "画像は最大4枚までアップロードできます")
    end
  end

  def validate_address
    if address.present?
      geocoded = Geocoder.search(address)
      if geocoded.blank? || geocoded.first&.coordinates.blank?
        errors.add(:address, "が有効な住所ではありません") # より具体的なメッセージに修正
      end
    else
    errors.add(:address, "を入力してください")
    end
  end

  def mock_geocode
    self.latitude = 35.6895 # 仮の緯度
    self.longitude = 139.6917 # 仮の経度
  end

  def self.ransackable_attributes(auth_object = nil)
    super + [ "id", "name", "address" ]
  end

  def self.ransackable_associations(auth_object = nil)
    super + [ "categories" ]
  end
end
