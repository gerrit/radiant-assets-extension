class Attachment < ActiveRecord::Base
  belongs_to :asset, :autosave => true
  belongs_to :page
  
  def uploads=(new_uploads)
    (asset || build_asset).uploads=new_uploads
  end
  
  def uploads
    (asset || build_asset).uploads
  end
end
