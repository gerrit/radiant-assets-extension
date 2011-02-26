# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'
require 'radiant-assets-extension/version'
require 'radiant-assets-extension/s3_store'

class AssetsExtension < Radiant::Extension
  version RadiantAssetsExtension::VERSION
  description 'Simple asset management (images and other uploads) for Radiant.'
  url 'http://ext.radiantcms.org/extensions/269-assets'
  
  extension_config do |config|
    path = '/assets'
    dragonfly = Dragonfly[:assets]
    dragonfly.configure_with(:imagemagick)
    dragonfly.configure_with(:rails)
    dragonfly.define_macro(ActiveRecord::Base, :image_accessor)    
    dragonfly.url_path_prefix = path
    if RadiantAssetsExtension::S3Store.enabled?
      dragonfly.datastore = RadiantAssetsExtension::S3Store.new
      dragonfly.datastore.configure do |c|
        c.use_filesystem = false
      end
    end
    
    config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :assets, path
  end
  
  def activate
    tab 'Content' do
      add_item 'Assets', '/admin/assets', :after => 'Pages'
    end
    admin.page.edit.add :form, 'admin/assets/attachments'
    ApplicationController.helper(:assets)
    Page.send :include, AssetTags
    Page.class_eval do
      has_many :attachments, :include => :asset
    end
  end
end
