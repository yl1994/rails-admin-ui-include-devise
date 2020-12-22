class ImageUploader < BaseUploader
  #添加白名单允许上传的扩展
  def extension_whitelist
    %w(jpg JPG jpeg JPEG gif GIF png PNG)
  end

  def store_dir
    "uploads/images/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
