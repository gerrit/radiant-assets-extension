class AddPositionToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :position, :integer
    Page.all(:include => :attachments).each do |page|
      page.attachments.each_with_index do |attachment, index|
        attachment.update_attributes :position => index+1
      end
    end
  end

  def self.down
    remove_column :attachments, :position
  end
end
