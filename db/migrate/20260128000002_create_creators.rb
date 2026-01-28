class CreateCreators < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:creators)
      create_table :creators do |t|
        t.references :user, null: true, foreign_key: true
        t.string :name, null: false
        t.text :description
        t.string :email
        t.string :avatar_url
        t.integer :assets_count, default: 0
        t.timestamps
      end
      
      add_index :creators, :name
      add_index :creators, :email, unique: true
    else
      # Add missing columns if table exists
      add_column :creators, :user_id, :bigint, if_not_exists: true
      add_column :creators, :description, :text, if_not_exists: true
      add_column :creators, :avatar_url, :string, if_not_exists: true
      add_column :creators, :assets_count, :integer, default: 0, if_not_exists: true
      
      add_foreign_key :creators, :users, if_not_exists: true
      add_index :creators, :email, unique: true, if_not_exists: true
    end
  end
end
