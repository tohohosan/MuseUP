require 'carrierwave/test/matchers'

RSpec.configure do |config|
    config.include CarrierWave::Test::Matchers

    config.after(:each) do
        FileUtils.rm_rf(Dir[Rails.root.join('public/uploads')])
    end
end
