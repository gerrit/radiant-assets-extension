# -*- encoding: utf-8 -*-
class AddCachingColumnsToAsset < ActiveRecord::Migration
  def self.up
    add_column :assets, :upload_name, :string
    add_column :assets, :upload_ext, :string
    add_column :assets, :upload_size, :integer
    add_column :assets, :upload_width, :integer
    add_column :assets, :upload_height, :integer
    puts "Updating existing assets…"
    Asset.all.each do |asset|
      asset.upload_name = asset.upload.name
      asset.upload_ext = asset.upload.ext
      asset.upload_size = asset.upload.size
      asset.upload_width = asset.upload.width
      asset.upload_height = asset.upload.height
      asset.save!
    end
  end

  def self.down
    remove_column :assets, :upload_name
    remove_column :assets, :upload_ext
    remove_column :assets, :upload_size
    remove_column :assets, :upload_width
    remove_column :assets, :upload_height
  end
end
