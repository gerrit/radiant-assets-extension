class Asset < ActiveRecord::Base
  image_accessor :upload
  validates_presence_of :upload
end
