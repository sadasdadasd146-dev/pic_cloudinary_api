class AddIndexToAssetsPhash < ActiveRecord::Migration[8.1]
  def change
    add_index :assets, :phash unless index_exists?(:assets, :phash)
    add_index :assets, :user_id unless index_exists?(:assets, :user_id)
  end
end
