class Asset < ActiveRecord::Base
  image_accessor :upload
  validates_presence_of :upload
  
  def format
     # HACK: relying on extension instead of using analyser and upload.format
     # analyser can throw us into very long loop when trying to identify
     # non-image files like word docs
     upload.ext.to_sym
  rescue UnableToHandle
    :generic
  end
  
  def image?
    # PDF is listed as supported but is only really supported by imagemagick
    # on systems that have gs installed
    return pdf_supported_as_image? if format == :pdf
    image_formats = Dragonfly::Encoding::ImageMagickEncoder.new.supported_formats
    image_formats.include?(format)
  end
  
  def to_s
    caption || upload.name
  end
private
  def pdf_supported_as_image?
    @pdf_supported ||= system('which gs')
  end
end
