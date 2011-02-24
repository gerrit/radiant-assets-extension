module ImagesHelper
  def image_listing(image)
    square_thumb(image) +
    content_tag(:span, image_link(image), :class=>'title')
  end
  
  def square_thumb(image, size=30)
    src = image.upload.thumb("#{size}x#{size}#").url
    image_tag(src, :width=>size, :height => size)
  end
  
  def image_link(image)
    link_to image.upload_uid, edit_admin_image_path(image)
  end
  
  def image_tag(*args)
    image = args.first
    if image && image.respond_to?(:upload)
      super image.upload.url, :width => image.upload.width, :height => image.upload.height
    else
      super(*args)
    end
  end
end
