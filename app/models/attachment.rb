require 'acts_as_list'

class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true, :autosave => true
  belongs_to :parent, :polymorphic => true
  
  acts_as_list :scope => :parent_id
  
  def self.reorder(new_order)
    new_order.each_with_index do |id, index|
      find(id).update_attributes! :position => index+1
    end
    new_order
  end
  
  def attached_to_page?
    parent_type == 'Page'
  end
  
  def asset
    attachable if attachable_type == 'Asset'
  end
  
  def uploads=(new_uploads)
    (self.attachable ||= Asset.new).uploads=new_uploads
  end
  
  def uploads
    (self.attachable ||= Asset.new).uploads
  end
end
