class AddImagesTable < ActiveRecord::Migration
  def self.up
    create_table :images do |table|
      table.column :upload_uid, :string
    end
  end

  def self.down
    drop_table
  end
end
