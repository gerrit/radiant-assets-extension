class Asset < ActiveRecord::Base
  # HACK: incomplete
  AUDIO_FORMATS = [:wav, :mp3, :m4a, :ogg]
  VIDEO_FORMATS = [:mp4, :avi]
  
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
    # PDF is listed as supported by imagemagick but thumbnailing etc. doesn't
    # work reliably so we treat it as a non-image
    return false if format == :pdf
    image_formats = Dragonfly::Encoding::ImageMagickEncoder.new.supported_formats
    image_formats.include?(format)
  end
  
  def audio?
    AUDIO_FORMATS.include?(format)
  end
  
  def video?
    VIDEO_FORMATS.include?(format)
  end
  
  def to_s
    caption || upload.name
  end
end
