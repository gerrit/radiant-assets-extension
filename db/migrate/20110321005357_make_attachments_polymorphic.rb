# -*- encoding: utf-8 -*-
class MakeAttachmentsPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :attachments, :page_id, :parent_id
    add_column :attachments, :parent_type, :string
    # use single quotes in query to be compatible with postgres
    Attachment.update_all "parent_type = 'Page'"

    rename_column :attachments, :asset_id, :attachable_id
    add_column :attachments, :attachable_type, :string
    # use single quotes in query to be compatible with postgres
    Attachment.update_all "attachable_type = 'Asset'"
  end

  def self.down
    warn 'This will delete all Attachments that aren’t attached to pages'
    remove_column :attachments, :parent_type
    rename_column :attachments, :parent_id, :page_id
  end
end
