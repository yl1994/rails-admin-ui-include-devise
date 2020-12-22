class TinymceImage < ApplicationRecord

    def extname
	    file.filename.split('.')[1] rescue ''
	end

    def image_ext
	    %w(jpg jpeg gif png)
	end

    def dyniamc_dir(file)
    	images_dir = ["#{Rails.root}/public/images", self.id].join("/")
        original_name = File.basename(self.file).split('.')[0]
        name ="#{original_name}-#{self.id}#{File.extname(file.original_filename).downcase}"
        # 保存图片的绝对路径

        Dir.mkdir(images_dir) unless File.exist?(images_dir)
	    save_image_url = [images_dir, name].join("/")
	    if !File.exist?(save_image_url) || File.size(save_image_url) < 1
        open(save_image_url, 'wb') do |img_file|
          img_file << open(file.path).read rescue ""
          # file << RestClient.get(aliyun_url).to_s rescue ""
        end
        self.update(url: "/images/#{self.id}/#{name}")
      end
    end

end
