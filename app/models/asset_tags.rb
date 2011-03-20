module AssetTags
  include Radiant::Taggable
  
  class TagError < StandardError;end
  
  desc %{
    Renders an image tag
    
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
    
    <r:image id="2" [size="400x200"] />
  }
  # TODO: accept width/height attributes and do something sensible like
  # resizing proportionally
  tag 'image' do |tag|
    asset = find_asset(tag)
    options = tag.attr.dup
    image = resized_or_original_image(asset, options.delete('size'))
    %{<img src="#{image.url}"#{html_attributes(options)}>}
  end
  
  desc %{
    Selects an asset. Does not render anything itself but gives access to the
    asset's attributes such as size
    
    <r:asset id="22"><r:url /></r:asset>
  }
  tag 'asset' do |tag|
    tag.locals.asset = find_asset(tag)
    tag.expand
  end
  
  desc %{
    Renders the URL of an asset
    
    Accepts optional size parameter in which case, if the asset is an image,
    the URL to a resized version of the image will be returned
    
    <r:asset:url [size="200x200"] id="22" />
  }
  tag 'asset:url' do |tag|
    image = resized_or_original_image(tag.locals.asset, tag.attr['size'])
    (image && image.url) || tag.locals.asset.url
  end
  
  %w[caption width height].each do |attribute|
    desc %{
      Renders the #{attribute} of the current asset
    }
    tag "asset:#{attribute}" do |tag|
      tag.locals.asset.send(attribute.to_sym)
    end
  end
  
  desc %{
    Renders contents if the current asset is an image
  }
  tag 'asset:if_image' do |tag|
    tag.expand if tag.locals.asset.image?
  end

  desc %{
    Renders contents if the current asset isn't an image
  }
  tag 'asset:unless_image' do |tag|
    tag.expand unless tag.locals.asset.image?
  end
  
  %w[landscape portrait].each do |orientation|
    desc %{
      Renders contents if the current image is in #{orientation} orientation
    }
    tag "asset:if_#{orientation}" do |tag|
      tag.expand if tag.locals.asset.send "#{orientation}?".to_sym
    end
    
    desc %{
      Renders contents if the current image isn't in #{orientation} orientation
    }
    tag "asset:unless_#{orientation}" do |tag|
      tag.expand unless tag.locals.asset.send "#{orientation}?".to_sym
    end
  end
  
  # Namespace only
  tag 'attachments' do |tag|
    tag.expand
  end
  
  desc %{
    Selects the first attached asset of the page and renders the tag's contents.
    If there are no assets on the page, nothing is rendered.
  }
  tag 'attachments:first' do |tag|
    if attachment = tag.locals.page.attachments.first
      tag.locals.asset = attachment.asset
      tag.expand
    end
  end
  
  tag 'attachments:each' do |tag|
    tag.locals.page.attachments.collect do |attachment|
      tag.locals.attachment = attachment
      tag.locals.asset = attachment.asset
      tag.expand
    end
  end
  
private
  def find_asset(tag)
    tag.locals.asset || Asset.find(tag.attr['id'])
  rescue ActiveRecord::RecordNotFound
    raise TagError, 'Please supply an id attribute'
  end
  
  def resized_or_original_image(asset, size)
    if asset.image?
      size ? asset.upload.process(:resize, size) : asset.upload
    end
  end
  
  def html_attributes(options)
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    " #{attributes}" unless attributes.empty?
  end
end
