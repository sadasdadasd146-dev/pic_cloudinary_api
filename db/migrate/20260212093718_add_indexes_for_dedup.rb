class AddIndexesForDedup < ActiveRecord::Migration[8.1]
  def change
    unless index_exists?(:assets, [:user_id, :phash])
      add_index :assets, [:user_id, :phash]
    end

    # ❌ ลบบรรทัดนี้ออกไปเลย เพราะมีแล้ว
    # add_index :job_del_pics, :asset_id, unique: true
  end
end
