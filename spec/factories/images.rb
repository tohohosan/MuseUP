FactoryBot.define do
  factory :image do
    association :museum

    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.jpg'), 'image/jpeg') }
  end
end
