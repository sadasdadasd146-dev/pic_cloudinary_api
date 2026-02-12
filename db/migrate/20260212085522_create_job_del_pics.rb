class CreateJobDelPics < ActiveRecord::Migration[8.1]
  def change
    create_table :job_del_pics do |t|
      t.references :asset, null: false, foreign_key: true
      t.float :similarity
      t.timestamps
    end
  end
end
