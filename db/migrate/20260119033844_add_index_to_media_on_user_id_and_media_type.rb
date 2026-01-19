class AddIndexToMediaOnUserIdAndMediaType < ActiveRecord::Migration[8.1]
  def change
    add_index :media, [:user_id, :media_type]
  end
end
