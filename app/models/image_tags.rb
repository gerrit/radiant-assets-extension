module ImageTags
  include Radiant::Taggable
  
  desc %{
    <r:image id="2" />
  }
  tag 'image' do |tag|
    image = Image.find(tag.attr['id'])
    job = image.upload
    %{<img src="#{job.url}" width="#{job.width}" height="#{job.height}"}
  end
end
