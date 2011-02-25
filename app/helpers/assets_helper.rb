module AssetsHelper
  def asset_listing(asset)
    icon(asset) +
    content_tag(:span, asset.to_s, :class=>'title')
  end
  
  def icon(asset, size=30)
    asset.image? ? square_thumb(asset, size) : text_icon(asset, size)
  end
  
  def text_icon(asset, size=30)
    css = "width:#{size}px;height:#{size}px;line-height:#{size}px"
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
  
  def display(asset)
    if @asset.image?
      content_tag :div, image_tag(@asset), :class => "image frame #{@asset.format}"
    elsif @asset.audio?
      audio_player(@asset)
    elsif @asset.video?
      video_player(@asset)
    elsif @asset.format == :pdf
      content_tag :iframe, '', :src => @asset.upload.url, :class => "pdf frame"
    end
  end
  
  def video_player(asset)
    %Q{<video src="#{asset.upload.url}" type="#{asset.upload.mime_type}" controls="controls">}
  end
  
  def audio_player(asset)
    %Q{<audio src="#{asset.upload.url}" type="#{asset.upload.mime_type}" controls="controls">}
  end
  
  def link_to_remove(asset)
    link_to 'Remove', remove_admin_asset_path(asset), :class => 'action remove', :title => 'Remove Asset'
  end
  
  def list_view?
    params[:view] == 'list'
  end
  
  def view_toggle
    if list_view?
      link_to 'Grid view', admin_assets_path(:view => 'grid')
     else
      link_to 'List view', admin_assets_path(:view => 'list')
    end
  end
end
