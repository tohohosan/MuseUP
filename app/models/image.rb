class Image < ApplicationRecord
  belongs_to :museum
  mount_uploader :file, ImageUploader

  validates :file, presence: true
end
