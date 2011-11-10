# -*- encoding: utf-8 -*-
class AddPositionToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :position, :integer
    Page.all.each do |page|
      page_attachments = Attachment.find_all_by_page_id page.id
      page_attachments.each_with_index do |attachment, index|
        attachment.update_attributes :position => index+1
      end
    end
  end

  def self.down
    remove_column :attachments, :position
  end
end
