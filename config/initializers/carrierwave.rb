require "carrierwave/storage/abstract"
require "carrierwave/storage/file"
require "carrierwave/storage/fog"

CarrierWave.configure do |config|
    if Rails.env.production?
        config.storage :fog
        config.fog_directory  = "museup-production"
        config.asset_host = "https://s3.ap-northeast-3.amazonaws.com/museup-production"
        config.fog_public = false
        config.fog_credentials = {
            provider: "AWS",
            aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
            region: "ap-northeast-3"
        }
    elsif Rails.env.development?
        config.storage :fog
        config.fog_directory  = "museup-development"
        config.asset_host = "https://s3.ap-northeast-3.amazonaws.com/museup-development"
        config.fog_public = false
        config.fog_credentials = {
            provider: "AWS",
            aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
            region: "ap-northeast-3"
        }
    else # test環境
        config.storage :file
        config.enable_processing = false
    end
end
