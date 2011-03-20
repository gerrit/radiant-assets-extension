require 'acts_as_list'

class Attachment < ActiveRecord::Base
  belongs_to :asset, :autosave => true
  belongs_to :page
  
  acts_as_list :scope => :page_id
  
  def uploads=(new_uploads)
    (asset || build_asset).uploads=new_uploads
  end
  
  def uploads
    (asset || build_asset).uploads
  end
end
