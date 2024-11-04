class Category < ApplicationRecord
    has_many :museum_categories, dependent: :destroy
    has_many :museums, through: :museum_categories

    validates :name, presence: true, uniqueness: true
end
