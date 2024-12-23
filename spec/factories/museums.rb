FactoryBot.define do
  factory :museum do
    name { "テスト博物館" }
    address { "東京都新宿区1-1-1" }
    description { "テスト説明" }
    url { "http://example.com" }
    latitude { 35.6895 }
    longitude { 139.6917 }

    association :user

    after(:build) do |museum|
      museum.categories << FactoryBot.build(:category)
    end

    after(:create) do |museum|
      museum.images << FactoryBot.create_list(:image, 4, museum: museum)
    end
  end
end
