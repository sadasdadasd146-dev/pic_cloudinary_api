class AddUniqueToJobDelPics < ActiveRecord::Migration[8.1]
  def change
    remove_index :job_del_pics, :asset_id
    add_index :job_del_pics, :asset_id, unique: true
  end
end
