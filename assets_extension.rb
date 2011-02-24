# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'
require 'radiant-assets-extension/version'
require 'dragonfly'

class AssetsExtension < Radiant::Extension
  version RadiantAssetsExtension::VERSION
  description "Simple asset management (images and other uploads) for Radiant."
  url "http://github"
  
  extension_config do |config|
    path = '/assets'
    dragonfly = Dragonfly[:assets]
    dragonfly.configure_with(:imagemagick)
    dragonfly.configure_with(:rails)
    dragonfly.url_path_prefix = path
    dragonfly.define_macro(ActiveRecord::Base, :image_accessor)    
    config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :assets, path
  end
  
  def activate
    tab 'Content' do
      add_item 'Assets', '/admin/assets', :after => 'Pages'
    end
    Page.send :include, AssetTags
  end
end
