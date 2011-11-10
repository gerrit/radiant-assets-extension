# -*- encoding: utf-8 -*-
# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'
require 'radiant-assets-extension'
require 'radiant-assets-extension/s3_store'

class AssetsExtension < Radiant::Extension
  version RadiantAssetsExtension::VERSION
  description 'Simple asset management (images and other uploads) for Radiant.'
  url 'http://ext.radiantcms.org/extensions/269-assets'
  
  extension_config do |config|
    path = '/assets'
    
    dragonfly = Dragonfly[:assets]
    dragonfly.configure_with(:imagemagick)
    # Overriding command to strip metadata from resized/converted images
    # see https://github.com/markevans/dragonfly/pull/61#issuecomment-1037694
    Dragonfly::ImageMagickUtils.convert_command = 'convert -strip'
    dragonfly.configure_with(:rails)
    dragonfly.define_macro(ActiveRecord::Base, :image_accessor)
    dragonfly.url_path_prefix = path
    # TODO: optional SSL support for url_host. could protocol-relative urls be used?
    dragonfly.url_host = 'http://' + Radiant::Config['assets.host'] unless Radiant::Config['assets.host'].blank?
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
    admin.page.edit.add :main, 'admin/assets/attachments', :after => :form
    ApplicationController.helper(:assets)
    Page.class_eval do
      include AssetTags
      has_many :attachments, :as => :parent, :order => :position, :dependent => :destroy
    end
  end
end
