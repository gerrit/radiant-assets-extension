require 'dragonfly'
require 'aws/s3'

module RadiantAssetsExtension
  # Subclass that allows connecting to S3 regions other than US-Standard
  class S3Store < Dragonfly::DataStorage::S3DataStore
    def self.enabled?
      Radiant::Config['assets.storage'] && Radiant::Config['assets.storage'] == 's3'
    end

    def self.region_hosts
      {
        'us-east-1' => 	's3.amazonaws.com',
        'us-west-1' => 's3-us-west-1.amazonaws.com',
        'eu-west-1' => 's3-eu-west-1.amazonaws.com',
        'ap-southeast-1' => 's3-ap-southeast-1.amazonaws.com'
      }
    end
    
    DEFAULT_BUCKET_NAME = 'radiant-assets-extension'
    
    def initialize(opts={})
      # HACK: AWS::S3 doesn't support S3 international regions properly
      # https://github.com/marcel/aws-s3/issues#issue/4/comment/411302
      # we monkey-patch the default host
      AWS::S3::DEFAULT_HOST.replace Radiant::Config['s3.host'] || self.class.s3_region_hosts['us-east-1']
      super({
        :bucket_name => Radiant::Config['s3.bucket'] || DEFAULT_BUCKET_NAME,
        :access_key_id => Radiant::Config['s3.key'],
        :secret_access_key => Radiant::Config['s3.secret']
      }.merge(opts))
    end
    
    def connect!
      AWS::S3::Base.establish_connection!(
        :server => "#{bucket_name}.s3.amazonaws.com",
        :access_key_id => access_key_id,
        :secret_access_key => secret_access_key
      )
    end
  end
end
