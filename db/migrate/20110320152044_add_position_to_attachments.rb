class AddPositionToAttachments < ActiveRecord::Migration
  def self.up
    rename_column :attachments, :page_id, :parent_id
    add_column :attachments, :position, :integer
    add_column :attachments, :parent_type, :string
    Attachment.update_all 'parent_type = "Page"'
    
    Page.all(:include => :attachments).each do |page|
      page.attachments.each_with_index do |attachment, index|
        attachment.update_attributes :position => index+1
      end
    end
  end

  def self.down
    warn 'This will delete all Attachments that aren’t attached to pages'
    remove_column :attachments, :parent_type
    remove_column :attachments, :position
    rename_column :attachments, :parent_id, :page_id
  end
end
