class Attachment < ActiveRecord::Base
  belongs_to :asset
  belongs_to :page
end
