class CreateAssets < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:assets)
      create_table :assets do |t|
        t.references :creator, null: false, foreign_key: true
        t.string :url, null: false
        t.string :cloudinary_id
        t.string :title
        t.text :description
        t.string :file_type
        t.integer :file_size
        t.integer :width
        t.integer :height
        t.timestamps
      end
      
      add_index :assets, :cloudinary_id
      add_index :assets, :creator_id
      add_index :assets, :created_at
    else
      # Add missing columns if table exists
      add_column :assets, :creator_id, :bigint, if_not_exists: true
      add_column :assets, :url, :string, if_not_exists: true
      add_column :assets, :cloudinary_id, :string, if_not_exists: true
      add_column :assets, :title, :string, if_not_exists: true
      add_column :assets, :description, :text, if_not_exists: true
      add_column :assets, :file_type, :string, if_not_exists: true
      add_column :assets, :file_size, :integer, if_not_exists: true
      add_column :assets, :width, :integer, if_not_exists: true
      add_column :assets, :height, :integer, if_not_exists: true
      
      add_foreign_key :assets, :creators, if_not_exists: true
      add_index :assets, :cloudinary_id, if_not_exists: true
      add_index :assets, :creator_id, if_not_exists: true
      add_index :assets, :created_at, if_not_exists: true
    end
  end
end
