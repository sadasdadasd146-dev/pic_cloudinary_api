class AddUniqueIndexToMedia < ActiveRecord::Migration[8.1]
  def change
    add_index :media, [:user_id, :media_type, :url], unique: true
  end
end
