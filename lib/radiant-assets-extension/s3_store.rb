require 'dragonfly'

module RadiantAssetsExtension
  # Subclass that allows connecting to S3 regions other than US-Standard
  class S3Store < Dragonfly::DataStorage::S3DataStore
    def connect!
      AWS::S3::Base.establish_connection!(
        :server => "#{bucket_name}.s3.amazonaws.com",
        :access_key_id => access_key_id,
        :secret_access_key => secret_access_key
      )
    end
  end
end
