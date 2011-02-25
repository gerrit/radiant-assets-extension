module AssetsHelper
  def asset_listing(asset)
    icon(asset) +
    content_tag(:span, asset.upload_uid, :class=>'title')
  end
  
  def icon(asset, size=30)
    asset.image? ? square_thumb(asset, size) : text_icon(asset, size)
  end
  
  def text_icon(asset, size=30)
    css = "width:#{size}px;height:#{size}px"
    content_tag(:span, asset.format, :class => "icon #{asset.format}", :style => css)
  end
  
  def square_thumb(image, size=30)
    src = image.upload.thumb("#{size}x#{size}#").url
    image_tag(src, :width=>size, :height => size, :class => "thumbnail #{image.format}")
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
