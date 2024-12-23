FactoryBot.define do
  factory :review do
    association :user
    association :museum

    content { "とてもよかったです！" }
    rating { "5" }
  end
end
