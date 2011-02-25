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
    assert_id_given(tag)
    image = find_image(tag)
    %{<img src="#{image.url}" width="#{image.width}" height="#{image.height}">}
  end
  
  desc %{
    Selects an asset. Does not render anything itself but gives access to the
    asset's attributes such as size
    
    Accepts optional @size@ attribute, see documentation for r:image
    
    <r:asset id="22" [size="200"]><r:url /></r:asset>
  }
  tag 'asset' do |tag|
    assert_id_given(tag)
    tag.locals.asset = find_image(tag)
    tag.expand
  end
  
  %w[url width height].each do |attribute|
    desc %{
      Renders the #{attribute} of the current asset
    }
    tag "asset:#{attribute}" do |tag|
      tag.locals.asset && tag.locals.asset.send(attribute.to_sym)
    end
  end
  
  desc %{
    Renders the caption of the current
  }
  tag 'asset:caption' do |tag|
    tag.locals.asset && tag.locals.asset.caption
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
  
private
  def assert_id_given(tag)
    raise TagError, 'Please supply an id attribute' unless tag.attr['id']
  end

  def find_image(tag)
    image = Image.find(tag.attr['id'])
    if(tag.attr['size'])
      image.upload.process(:resize, tag.attr['size'])
    else
      image.upload
    end
  end
end
