class RemoveIndexMediaOnUserId < ActiveRecord::Migration[8.1]
  def change
    # ระบุคอลัมน์ที่ต้องการลบดัชนี
    remove_index :media, name: "index_media_on_user_id_and_media_type_and_url"
    remove_index :media, name: "index_media_on_user_id_and_media_type"
  end
end