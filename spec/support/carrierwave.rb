require 'carrierwave/test/matchers'

RSpec.configure do |config|
    config.include CarrierWave::Test::Matchers

    # CarrierWave のアップローダ設定をモック化
    config.before(:suite) do
        # テスト用にローカルストレージを使用
        CarrierWave.configure do |config|
            config.storage = :file
            config.enable_processing = false
        end
    end

    config.after(:each) do
        # アップロードされたファイルを削除
        if Rails.env.test?
            FileUtils.rm_rf(Dir[Rails.root.join('public/uploads')])
        end
    end
end
