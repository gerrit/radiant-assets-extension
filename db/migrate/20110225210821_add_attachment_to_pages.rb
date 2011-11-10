# -*- encoding: utf-8 -*-
class AddAttachmentToPages < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.belongs_to :asset
      t.belongs_to :page
    end
  end

  def self.down
    drop_table :attachments
  end
end
