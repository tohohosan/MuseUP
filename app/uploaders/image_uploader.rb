class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production? || Rails.env.development?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [ 800, 800 ]

  process :convert_to_webp

  def convert_to_webp
    manipulate! do |img|
      img.format("webp") { |b| b }
      img
    end
  end

  def filename
    if original_filename.present? && !Rails.env.test?
      super.chomp(File.extname(super)) + ".webp"
    else
      super
    end
  end

  def extension_allowlist
    %w[jpg jpeg gif png webp]
  end
end
