class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # 保存先のストレージ設定
  storage :fog

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
      img.format("webp")
      img = yield(img) if block_given?
      img
    end
  end

  # 拡張子を変更
  def filename
    super.chomp(File.extname(super)) + ".webp" if original_filename.present?
  end

  # 許可するファイル形式
  def extension_allowlist
    %w[jpg jpeg gif png]
  end
end
