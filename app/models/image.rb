class Image < ApplicationRecord
  belongs_to :museum
  mount_uploader :file, ImageUploader

  validates :file, presence: true
  validate :validate_image_size

  private

  def validate_image_size
    if file.attached? && file.blob.byte_size > 3.megabytes
      errors.add(:file, "ファイルサイズは3MB以内にしてください")
    end
  end
end
