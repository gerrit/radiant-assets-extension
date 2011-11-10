# -*- encoding: utf-8 -*-
module AssetsHelper  
  def asset_listing(asset)
    asset_icon(asset) +
    content_tag(:span, asset.to_s, :class=>'title')
  end
  
  def asset_grid_item(asset)
    asset_icon(asset, 120) +
    content_tag(:span, "ID: #{asset.id}", :class => 'id') +
    content_tag(:span, asset.to_s, :class => 'caption')
  end
  
  def asset_icon(asset, size=30)
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
    other = list_view? ? 'grid' : 'list'
    link_to "Switch to #{other} view", admin_assets_path(:view => other)
  end
end
