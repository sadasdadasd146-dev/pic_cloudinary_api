# db/migrate/xxxx_add_unique_index_to_assets.rb
class AddUniqueIndexToAssets < ActiveRecord::Migration[8.1]
  def change
    add_index :assets,
      [:user_id, :url, :media_type],
      unique: true,
      name: "index_assets_unique_per_user_and_type"
  end
end
