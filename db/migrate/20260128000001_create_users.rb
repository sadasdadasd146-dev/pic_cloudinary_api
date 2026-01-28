class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :username, null: false
        t.string :email
        t.string :password_digest
        t.boolean :admin, default: false
        t.timestamps
      end
      
      add_index :users, :username, unique: true
      add_index :users, :email, unique: true
    else
      # Add missing columns if table exists
      add_column :users, :email, :string, if_not_exists: true
      add_column :users, :password_digest, :string, if_not_exists: true
      add_column :users, :admin, :boolean, default: false, if_not_exists: true
    end
  end
end
