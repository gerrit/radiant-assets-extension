class AddTimestampsAndLockingToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :lock_version, :integer, :default => 0
    add_column :assets, :created_at, :datetime
    add_column :assets, :updated_at, :datetime
    puts 'Updating current assets with dates'
    Asset.all.each do |asset|
      asset.created_at = Time.now
      asset.updated_at = Time.now
      asset.save!
    end
  end

  def self.down
    remove_column :assets, :updated_at
    remove_column :assets, :created_at
    remove_column :assets, :lock_version
  end
end
