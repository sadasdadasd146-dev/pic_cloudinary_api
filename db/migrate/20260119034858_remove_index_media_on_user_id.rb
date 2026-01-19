class RemoveIndexMediaOnUserId < ActiveRecord::Migration[8.1]
  def change
    remove_index :media, name: "index_media_on_user_id"
  end
end
