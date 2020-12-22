class UserSignatureUploader < ImageUploader

  #添加白名单允许上传的扩展
  def extension_whitelist
    %w(jpg JPG jpeg JPEG  png PNG)
  end

  def store_dir
    "uploads/user_signature/#{model.id}"
  end
end
