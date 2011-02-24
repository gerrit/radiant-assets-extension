module AssetTags
  include Radiant::Taggable
  
  desc %{
    Renders an image tag
    
    Examples of possible values for the size attribute
    
    '400x300'            # resize, maintain aspect ratio
    '400x300!'           # force resize, don't maintain aspect ratio
    '400x'               # resize width, maintain aspect ratio
    'x300'               # resize height, maintain aspect ratio
    '400x300>'           # resize only if the image is larger than this
    '400x300<'           # resize only if the image is smaller than this
    '50x50%'             # resize width and height to 50%
    '400x300^'           # resize width, height to minimum 400,300, maintain aspect ratio
    '2000@'              # resize so max area in pixels is 2000
    '400x300#'           # resize, crop if necessary to maintain aspect ratio (centre gravity)
    '400x300#ne'         # as above, north-east gravity
    '400x300se'          # crop, with south-east gravity
    '400x300+50+100'     # crop from the point 50,100 with width, height 400,300
    
    <r:image id="2" [size="400x200"] />
  }
  # TODO: accept width/height attributes and do something sensible like
  # resizing proportionally
  tag 'image' do |tag|
    image = Image.find(tag.attr['id'])
    job = if(tag.attr['size'])
      image.upload.process(:resize, tag.attr['size'])
    else
      image.upload
    end
    %{<img src="#{job.url}" width="#{job.width}" height="#{job.height}">}
  end
end
