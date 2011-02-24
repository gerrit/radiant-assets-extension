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
    
    # HACK: AWS::S3 doesn't support S3 EU region 
    # https://github.com/marcel/aws-s3/issues#issue/4/comment/411302
    # we monkey-patch the default host and hardcode it to Europe
    s3_region_hosts = {
      'us-east-1' => 	's3.amazonaws.com',
      'us-west-1' => 's3-us-west-1.amazonaws.com',
      'eu-west-1' => 's3-eu-west-1.amazonaws.com',
      'ap-southeast-1' => 's3-ap-southeast-1.amazonaws.com'
    }
    AWS::S3::DEFAULT_HOST.replace Radiant::Config['s3.host'] || s3_region_hosts['us-east-1']
    
    dragonfly.datastore = RadiantAssetsExtension::S3Store.new
    dragonfly.datastore.configure do |d|
      d.bucket_name = Radiant::Config['s3.bucket'] || 'radiant-assets-extension'
      d.access_key_id = Radiant::Config['s3.key']
      d.secret_access_key = Radiant::Config['s3.secret']
    end
    
    config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :assets, path
  end
  
  def activate
    tab 'Content' do
      add_item 'Assets', '/admin/assets', :after => 'Pages'
    end
    Page.send :include, AssetTags
  end
end
