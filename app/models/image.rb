class Image < ApplicationRecord
  belongs_to :user
  belongs_to :museum
  validates :image, presence: true
end
