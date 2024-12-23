FactoryBot.define do
  factory :list do
    association :user
    name { "お気に入りリスト" }
    default { false }
  end
end
