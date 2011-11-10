# -*- encoding: utf-8 -*-
class RenameModelClass < ActiveRecord::Migration
  def self.up
    rename_table :images, :assets
  end

  def self.down
    rename_table :assets, :images
  end
end
