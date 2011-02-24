# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'
require 'radiant-images-extension/version'
require 'dragonfly'

class ImagesExtension < Radiant::Extension
  version RadiantImagesExtension::VERSION
  description "Adds images to Radiant."
  url "http://yourwebsite.com/images"
  
  extension_config do |config|
    
    dragonfly = Dragonfly[:images]
    dragonfly.configure_with(:imagemagick)
    dragonfly.configure_with(:rails)
    dragonfly.define_macro(ActiveRecord::Base, :image_accessor)
    
    config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :images, '/media'
  end
  
  def activate
    tab 'Content' do
      add_item "Images", "/admin/images", :after => "Pages"
    end
  end
end
