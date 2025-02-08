class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick # mini_magickを使用するための記述

  # 環境ごとのストレージ設定
  if Rails.env.production? || Rails.env.development?
    storage :fog
  else
    storage :file # テスト環境では file ストレージを使用
  end

  # アップロードしたファイルの保存ディレクトリ
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # アップロード時にサイズを変更
  process resize_to_fit: [ 800, 800 ]

  # WebP に変換
  process :convert_to_webp

  def convert_to_webp
    manipulate! do |img|
      img.format("webp") { |b| b }
      img
    end
  end

  # 拡張子を変更
  def filename
    if original_filename.present? && !Rails.env.test?
      super.chomp(File.extname(super)) + ".webp"
    else
      super
    end
  end

  # 許可するファイル形式
  def extension_allowlist
    %w[jpg jpeg gif png webp]
  end
end
