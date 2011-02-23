# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'
require 'radiant-images-extension/version'
class ImagesExtension < Radiant::Extension
  version RadiantImagesExtension::VERSION
  description "Adds images to Radiant."
  url "http://yourwebsite.com/images"
  
  # extension_config do |config|
  #   config.gem 'some-awesome-gem
  #   config.after_initialize do
  #     run_something
  #   end
  # end

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate
    # tab 'Content' do
    #   add_item "Images", "/admin/images", :after => "Pages"
    # end
  end
end
