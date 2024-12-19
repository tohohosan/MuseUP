require "carrierwave/storage/abstract"
require "carrierwave/storage/file"
require "carrierwave/storage/fog"

CarrierWave.configure do |config|
    if Rails.env.production? || Rails.env.development? # 開発中もs3使う
        config.storage :fog
        config.fog_directory  = "museup-#{Rails.env}"
        config.asset_host = "https://s3.ap-northeast-3.amazonaws.com/museup-#{Rails.env}"
        config.fog_public = false
        config.fog_credentials = {
            provider: "AWS",
            aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"], # AWSのaccess_key_id
            aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"], # AWSのsecret_access_key
            region: "ap-northeast-3"
          # path_style: true
        }
    else
        config.storage :file
        config.enable_processing = false if Rails.env.test?
    end
end
