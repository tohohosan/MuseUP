class Museum < ApplicationRecord
  belongs_to :user
  has_many :images, dependent: :destroy
  has_many :museum_categories, dependent: :destroy
  has_many :categories, through: :museum_categories

  validates :name, :address, presence: true
end
