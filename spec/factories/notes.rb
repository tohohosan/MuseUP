FactoryBot.define do
  factory :note do
    association :user
    association :museum

    content { "興味深い博物館だった。" }
  end
end
