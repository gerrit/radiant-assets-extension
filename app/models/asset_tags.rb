# -*- encoding: utf-8 -*-
module AssetTags
  include Radiant::Taggable
  class TagError < StandardError;end
  
  desc %{
    Renders an image tag for the current asset (if it’s an image)
    
    You can resize the image using the @width@, @height@ and @size@ attributes.
    
    Using @width@ and/or @height@ will resize the image to the specified
    width/height maintaining the aspect ratio. For more complex resizing operations
    you can use the @size@ attribute which will override any supplied
    width/height attributes.
    
    Examples of possible values for the @size@ attribute
    
    '400x300'            resize, maintain aspect ratio
    '400x300!'           force resize, don't maintain aspect ratio
    '400x'               resize width, maintain aspect ratio
    'x300'               resize height, maintain aspect ratio
    '400x300>'           resize only if the image is larger than this
    '400x300<'           resize only if the image is smaller than this
    '50x50%'             resize width and height to 50%
    '400x300^'           resize width, height to minimum 400,300, maintain aspect ratio
    '2000@'              resize so max area in pixels is 2000
    '400x300#'           resize, crop if necessary to maintain aspect ratio (centre gravity)
    '400x300#ne'         as above, north-east gravity
    '400x300se'          crop, with south-east gravity
    '400x300+50+100'     crop from the point 50,100 with width, height 400,300
    
    *Usage:* 
    
    <pre><code><r:image id="2" [width="200"] [height="400"] [size="400x200"] /></code></pre>
  }
  tag 'image' do |tag|
    assign_asset_and_upload!(tag)
    if tag.locals.asset.image?
      img = (tag.locals.asset_upload ||= tag.locals.asset.upload)
      fill_dimension_attributes!(tag)
      %{<img src="#{img.url}"#{html_attr_string(tag.attr.except('size'))}>}
    end
  end
  
  desc %{
    Selects an asset. Does not render anything itself but gives access to the
    asset's attributes such as @caption@, @url@ and @width@/@height@
    
    Accepts optional @size@ parameter in which case, if the asset is an image,
    the asset is resized and any child @url@, @width@ and @height@ tags will refer
    to the resized image.
    
    *Usage:*
    
    <pre><code><r:asset id="22" [size="200x200"]>...</r:asset></code></pre>
    
    *Examples:*
    
    Will render URL to original uploaded file
    <pre><code><r:asset id="66"><r:url /></r:asset></code></pre>
    
    Will render render height of resized image (500)
    <pre><code><r:asset id="66" size="x500">New Height: <r:height />px</r:asset></code></pre>
  }
  tag 'asset' do |tag|
    assign_asset_and_upload!(tag)
    tag.expand
  end
  
  # NOTE: width/height tags require analysing the image if you resized it
  # this can be quite slow. Avoid using with resized images.
  %w[url width height].each do |attribute|
    desc %{
      Renders the #{attribute} of the current asset
            
      Accepts optional size parameter in which case, if the asset is an image,
      the #{attribute} to a resized version of the image will be returned.
      
      *Usage:*
      
      <pre><code><r:asset:#{attribute} [size="200x200"] id="22" /></code></pre>
    }
    tag "asset:#{attribute}" do |tag|
      assign_asset_and_upload!(tag)
      (tag.locals.asset_upload ||= tag.locals.asset.upload).send(attribute.to_sym)
    end
  end

  desc %{
    Renders the caption of the current asset
  }
  tag 'asset:caption' do |tag|
    assign_asset_and_upload!(tag)
    tag.locals.asset.caption
  end
  
  desc %{
    Renders its contents if the current asset is an image
  }
  tag 'asset:if_image' do |tag|
    assign_asset_and_upload!(tag)
    tag.expand if tag.locals.asset.image?
  end

  desc %{
    Renders its contents if the current asset isn't an image
  }
  tag 'asset:unless_image' do |tag|
    assign_asset_and_upload!(tag)
    tag.expand unless tag.locals.asset.image?
  end
  
  %w[landscape portrait].each do |orientation|
    desc %{
      Renders its contents if the current image is in #{orientation} orientation
    }
    tag "asset:if_#{orientation}" do |tag|
      assign_asset_and_upload!(tag)
      tag.expand if (tag.locals.asset_upload ||= tag.locals.asset.upload).send "#{orientation}?".to_sym
    end
    
    desc %{
      Renders its contents if the current image isn't in #{orientation} orientation
    }
    tag "asset:unless_#{orientation}" do |tag|
      assign_asset_and_upload!(tag)
      tag.expand unless (tag.locals.asset_upload ||= tag.locals.asset.upload).send "#{orientation}?".to_sym
    end
  end
  
  # Namespace only
  tag 'attachments' do |tag|
    tag.expand
  end
  
  desc %{
    Renders the tag’s contents if the page has any assets attached.
  }
  tag 'if_attachments' do |tag|
    tag.expand if tag.locals.page.attachments.any?
  end

  desc %{
    Renders the tag’s contents if the page has no assets attached.
  }
  tag 'unless_attachments' do |tag|
    tag.expand unless tag.locals.page.attachments.any?
  end
  
  desc %{
    Renders the tag‘s contents with the first attached asset of the current
    page selected.
    
    If there are no assets on the page, nothing is rendered.
  }
  tag 'attachments:first' do |tag|
    if attachment = tag.locals.page.attachments.first
      tag.locals.attachment = attachment
      tag.locals.asset = attachment.asset
      tag.expand
    end
  end
  
  
  desc %{
    Cycles through the attachments of the current page and renders the tag’s
    contents for each of them.
  }
  # TODO: arbitrary ordering and limiting
  tag 'attachments:each' do |tag|
    tag.locals.page.attachments.collect do |attachment|
      tag.locals.attachment = attachment
      tag.locals.asset = attachment.asset
      tag.expand
    end
  end
  
private
  def assign_asset_and_upload!(tag)
    assign_asset!(tag)
    assign_upload!(tag)
  end
  
  def assign_asset!(tag)
    if tag.attr['id']
      tag.locals.asset = Asset.find(tag.attr['id'])
    else
      tag.locals.asset || raise(TagError, 'Please supply an id attribute')
    end
  end
  
  def fill_dimension_attributes!(tag)
    # Can't use aspect_ratio here because it's not cached on the model
    # Using it would require analysing the image which we want to postpone
    # The original height/width are cached on upload though
    aspect_ratio = tag.locals.asset.width.to_f / tag.locals.asset.height.to_f
    if tag.attr['width'] && tag.attr['height']
      return
    elsif tag.attr['width']
      tag.attr['height'] = (tag.attr['width'].to_i / aspect_ratio).to_i
    elsif h = tag.attr['height']
      tag.attr['width'] = (tag.attr['height'].to_i * aspect_ratio).to_i
    end
  end
  
  def assign_upload!(tag)
    tag.attr['size'] ||= build_geometry_string(tag.attr['width'], tag.attr['height'])
    tag.locals.asset_upload = if tag.attr['size']
      tag.locals.asset.upload.process(:resize, tag.attr['size'])
    end
  end
  
  def build_geometry_string(width, height)
    if width && height
      "#{width}x#{height}"
    elsif width
      "#{width}x"
    elsif height
      "x#{height}"
    end
  end
  
  def html_attr_string(hash)
    attributes = hash.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    " #{attributes}" unless attributes.empty?
  end
end
