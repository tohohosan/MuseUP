FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password123" } # 6文字以上のパスワード
    password_confirmation { "password123" }
    name { "User One" }
  end
end
