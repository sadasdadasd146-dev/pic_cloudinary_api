# db/migrate/20260128094504_create_assets.rb
class CreateAssets < ActiveRecord::Migration[8.1]
  def change
    create_table :assets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :media_type, null: false
      t.text :url, null: false

      t.string :title
      t.string :author_name
      t.string :author_avatar
      t.datetime :upload_date
      t.string :tags, array: true, default: []

      t.timestamps
    end
  end
end
