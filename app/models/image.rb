class Image < ApplicationRecord
  belongs_to :museum
  mount_uploader :file, ImageUploader

  validates :file, presence: true
  validate :validate_image_size

  private

  def validate_image_size
    if file.present? && file.size > 5.megabytes
      errors.add(:file, "ファイルサイズは5MB以内にしてください")
    end
  end
end
