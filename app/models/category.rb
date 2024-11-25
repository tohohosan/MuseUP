class Category < ApplicationRecord
    has_many :museum_categories, dependent: :destroy
    has_many :museums, through: :museum_categories

    validates :name, presence: true, uniqueness: true

    private

    def self.ransackable_attributes(auth_object = nil)
        super + [ "name" ]
    end

    def self.ransackable_associations(auth_object = nil)
        super + [ "museum_categories", "museums" ]
    end
end
