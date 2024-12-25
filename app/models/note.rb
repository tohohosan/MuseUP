class Note < ApplicationRecord
  belongs_to :user
  belongs_to :museum

  validates :content, presence: true, length: { maximum: 1000 }
end
