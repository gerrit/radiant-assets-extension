class MakeAttachmentsPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :attachments, :asset_id, :attachable_id
    add_column :attachments, :attachable_type, :string
    Attachment.update_all 'attachable_type = "Asset"'
  end

  def self.down
    remove_column :attachments, :attachable_type
    rename_column :attachments, :attachable_id, :asset_id
  end
end
